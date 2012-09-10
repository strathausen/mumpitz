###

mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>

###

require 'coffee-script'

_         = require 'underscore'
async     = require 'async'
yamlGhm   = require './plugins/yamlGhm'
renderer  = require './plugins/renderer'
fileSaver = require './plugins/fileSaver'

class Mumpitz
  module.exports = Mumpitz
  constructor: (properties) ->
    @blog = new class Blog
    _.defaults @blog, properties
    _.defaults @blog,
      articles : []
      template : __dirname + '/theme/article.mustache'
    
  go: (cb) ->
    blog = @blog
    plugins = [ yamlGhm, renderer, fileSaver ]
    async.series (plugins.map (p) -> async.apply p, blog), cb
