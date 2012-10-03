###

mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>

###

require 'coffee-script'

_         = require 'underscore'
fs        = require 'fs'
path      = require 'path'
async     = require 'async'
# Plugins, implementing the stream api
es        = require 'event-stream'
yamlmd    = require 'yamlmd'
schnauzer = require 'schnauzer'
defaultTo = require './plugins/defaultTo'
intercept = require './plugins/intercept'

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
    
  go: (cb) ->
    fs.readdir @blog.dir, (err, docs) =>
      #console.error docs
      #return do cb
      async.forEach docs, ((doc, cb) =>
        return do cb unless /\.(markdown|yamlmd)$/.test doc
        props = {}
        rs = fs.createReadStream path.join @blog.dir, doc
        rs
          .pipe(yamlmd.stream())
          .pipe(defaultTo @blog)
          .pipe(intercept (item) =>
            console.error item
            @blog.documents.push item
          )
          .pipe(schnauzer.stream())
          .pipe(process.stdout)
      ), cb

unless module.parent
  mu = new Mumpitz
    dir: __dirname + '/example/articles'
    layout: __dirname + '/example/theme/layout.hbs'
  mu.go console.log
