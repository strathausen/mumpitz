###

Save stuff to file system

###

path     = require 'path'
fs       = require 'fs'
async    = require 'async'
qs       = require 'querystring'

module.exports = ({ public, dir, articles }, cb) ->
  async.forEach articles, (({ id, plain }, cb) ->
    id or= 'index'
    newId = qs.escape id #id.replace /\//g, ('\' + '/')
    newName = path.join (public or dir), newId + '.html'
    console.error { newId, newName }
    fs.writeFile newName, plain, 'utf8', cb
  ), cb
