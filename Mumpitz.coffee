###

mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>

###

require 'coffee-script'

_         = require 'underscore'
async     = require 'async'
# Plugins, implementing the stream api
yamlmd    = require 'yamlmd'
schnauzer = require 'schnauzer'

class Mumpitz
  module.exports = Mumpitz
  constructor: (properties) ->
    unless properties.dir
      throw new Error 'please specify "dir" where your articles are'
    @blog = new class Blog
    _.defaults @blog, properties
    _.defaults @blog,
      documents : []
      template  : __dirname + '/theme/article.mustache'
    
  go: (cb) ->
    async.series (plugins.map (p) -> async.apply p, blog), cb
