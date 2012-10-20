es = require 'event-stream'
_  = require 'underscore'

module.exports = (defaults) -> es.map (data, cb) ->
  cb null, _.defaults data, defaults
