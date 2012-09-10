Blog = require '../../Colbo'

config =
  # mandatory
  dir    : __dirname + '/articles'

  # these are optional!
  layout : __dirname + '/../../theme/layout.mustache'

blog = new Blog config

# an example blog setup
blog.on 'ready', ->
  blog.app.listen 3000
  console.log 'listening at port ' + blog.app.address().port

# can do funny connect things with blog:
# blog.app.listen 3000
# blog.app.route (app) ->
#   app.get '/special', (req, res) -> res.send special: yes
# blog.app.config -> ...
