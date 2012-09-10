###

loading yaml-markdowny files from disk into an article model

creates properties content and metadata from the yaml file

@author johann philipp strathausen <strathausen@gmail.com>

###
_       = require 'underscore'
async   = require 'async'
fs      = require 'fs'
path    = require 'path'
yaml    = require 'yaml'
ghm     = require 'ghm'

# file extension regex
match = /[\.](md|markdown)$/i

# load all matching files from a directory
module.exports = (blog, cb) ->

  # read a file's content
  # split into yaml and markdown part separated by two newlines \n\n
  # create an article object
  reader = (fname, cb) ->
    fs.readFile (path.join blog.dir, fname), 'utf8', (err, content) ->

      # split file content into yaml and markdown part
      [ head, tail... ] = content.split '\n\n'

      # parse yaml part (metadata)
      _.extend (data = {}), ((head.split '\n').map yaml.eval)...

      # parse markdown part and render to html (content)
      data.content = ghm.parse tail.join '\n\n'

      # create an ID from filename if it does not exist in the yaml part
      _.defaults data, blog: blog, id: fname.replace match, ''

      # deliver the freshly baken article object
      cb err, data

  fs.readdir blog.dir, (err, files) =>
    return cb err if err
    files = files.filter (f) -> match.test f
    async.map files, reader, (err, articles) ->
      articles = _.sortBy articles, (a) -> -a.sort or 0
      blog.articles.push articles...
      cb err
