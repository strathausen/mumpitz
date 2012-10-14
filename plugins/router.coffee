es        = require 'event-stream'
# in memory stream cacher serving pipes as paths
module.exports = (app) -> (path) -> es.map (data, cb) ->
  url = "/#{path}"
  console.log url, path
  app.use (req, res, next) ->
    console.error req.url, url
    return do next unless req.url is url
    res.setHeader 'Content-Type', 'text/html; charset=utf8'
    res.setHeader 'Content-Length', data.length
    res.write data, 'binary'
    res.end()
  do cb
