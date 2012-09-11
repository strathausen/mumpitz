###

mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>

###

require 'coffee-script'

_         = require 'underscore'
async     = require 'async'
yamlmd    = require 'yamlmd'
renderer  = require './plugins/renderer'

class Mumpitz
  module.exports = Mumpitz
  constructor: (properties) ->
    unless properties.dir
      throw new Error 'please specify "dir" where your articles are'
    @blog = new class Blog
    _.defaults @blog, properties
    _.defaults @blog,
      articles : []
      template : __dirname + '/theme/article.mustache'
    
  go: (cb) ->
    fs.
    async.series (plugins.map (p) -> async.apply p, blog), cb
