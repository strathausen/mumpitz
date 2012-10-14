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
connect   = require 'connect'
# Plugins, implementing the stream api
yamlmd    = require 'yamlmd'
schnauzer = require 'schnauzer'
defaultTo = require './plugins/defaultTo'
intercept = require './plugins/intercept'
router    = require './plugins/router'

class Mumpitz
  module.exports = Mumpitz
  constructor: (properties) ->
    # This option is mandatory
    unless properties.dir
      throw new Error 'please specify "dir" where your articles are'
    
    @defaults = properties
    @blog = new class Blog
    _.defaults @blog, properties
    _.defaults @blog,
      documents : []
      template  : __dirname + '/example/theme/article.hbs'
      app       : connect()
    @router = router @blog.app
    
  go: (cb) ->
    EXTREG = /\.(md|markdown|yamlmd)$/
    fs.readdir @blog.dir, (err, docs) =>
      return cb err if err
      async.forEach docs, ((doc, cb) =>
        return do cb unless EXTREG.test doc
        console.log 'here', doc
        url = null
        readStream = fs.createReadStream path.join @blog.dir, doc
        readStream
          .pipe(yamlmd.stream())
          .pipe(defaultTo @blog)
          .pipe(defaultTo id: (doc.replace EXTREG, ''))
          .pipe(intercept((item) => @blog.documents.push item))
          .pipe(intercept (item) => url = item.id)
          .pipe(schnauzer.stream())
          .pipe(@router(url)).on 'end', ->
            console.log url
            do cb
      ), cb

unless module.parent
  mu = new Mumpitz
    dir    : __dirname + '/example/articles'
    layout : __dirname + '/example/theme/layout.hbs'
  mu.go ->
    console.error 'done'
    mu.blog.app.listen 3000
