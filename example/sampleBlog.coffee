Mumpitz = require '../'

blog = new Mumpitz dir : __dirname + '/articles'
blog.go (err) ->
  throw err if err
  console.log 'yeah'
