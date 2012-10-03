es = require 'event-stream'
module.exports = (fn) -> es.map (data, cb) ->
  fn data
  cb null, data
