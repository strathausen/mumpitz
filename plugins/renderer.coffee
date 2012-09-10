###

renderer for mustache templates.

@author johann philipp strathausen <strathausen@gmail.com>

###

fs        = require 'fs'
path      = require 'path'
hogan     = require 'hogan.js'
async     = require 'async'
match     = /\.mustache$/i
templates = {}

templater = ({ template, layout}, article) ->
  tpl = layout or template
  partial = if layout? then (body: templates[template]) else {}
  templates[tpl].render article, partial

loader = ({ layout, template }, next) ->
  async.forEach [layout, template], ((item, next) ->
    if templates[item]? or not item
      return do next
    fs.readFile item, 'utf8', (err, tplData) ->
      templates[item] = hogan.compile tplData
      next err
  ), next

Renderer = (blog) -> (article) ->
  template = article.template or blog.template
  layout   = article.layout or blog.layout
  article.plain = templater { template, layout }, article

module.exports = (blog, cb) ->
  async.series [
    async.apply loader, blog
    async.apply async.forEach, blog.articles, loader
  ], (err) ->
    blog.articles.map Renderer blog
    cb err
