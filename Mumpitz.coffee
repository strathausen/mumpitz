###

Mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>

###

require 'coffee-script'

_         = require 'underscore'
fs        = require 'fs'
path      = require 'path'
async     = require 'async'
es        = require 'event-stream'
moment    = require 'moment'
# Plugins implementing the stream api
yamlmd    = require 'yamlmd'
schnauzer = require 'schnauzer'
defaultTo = require './plugins/defaultTo'
intercept = require './plugins/intercept'
DOCEXT = /\.(md|markdown|yamlmd)$/

class Mumpitz
  module.exports = Mumpitz
  constructor: (properties) ->
    # This option is mandatory
    unless properties.dir
      throw new Error 'please specify "dir" where your articles are'

    @blog = new class MumpitzBlog
    _.defaults @blog, properties
    _.defaults @blog,
      template: path.join(__dirname, 'example/theme/article.hbs')

  documents: []
  go: (cb) ->
    # Functions waiting here until they get executed
    waiters = []
    fs.readdir @blog.dir, (err, docs) =>
      return cb err if err
      async.forEach docs, ((doc, cb) =>
        return do cb unless DOCEXT.test doc
        docName = doc.replace DOCEXT, ''
        outDir = @blog.public or @blog.dir
        # If there's already an extension, don't add another one
        # otherwise, you should not have dots in your file names
        outDoc = docName + unless /^.+\.[\w]+$/.test docName then '.html' else ''
        readStream = fs.createReadStream (path.join @blog.dir, doc)
        writeStream = fs.createWriteStream (path.join outDir, outDoc)
        readStream
          .pipe(es.join(''))
          .pipe(yamlmd.stream())
          # Default properties
          .pipe(defaultTo @blog)
          .pipe(defaultTo id: docName)
          # Build doc index
          .pipe(intercept (item) => @documents.push item)
          # Synchronise here until all items have got here
          .pipe(es.map (item, next) ->
            waiters.push -> next null, item
            do cb
          )
          .pipe(schnauzer.stream())
          .pipe(writeStream)
      ), =>
        # Sorting documents by date (if possible)
        @documents = _.sortBy @documents, (doc) ->
          return 0 unless doc.date?
          date = doc.date.replace /([0-9]+)(st|nd|rd|th|)/g, '$1'
          -moment(date).unix()
        # Attaching documents to each document
        @documents.forEach (doc) =>
          doc.documents = @documents
        # Now, get back to work everybody!
        waiters.forEach (f) -> do f
        do cb
