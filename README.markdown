# colbo

a very fast blog engine. speed is king.

## features

content and rendered pages are stored in memory. should be very fast.

incoming requests are answered with pre-rendered in-memory copies of the
complete page. the store in memory is being updated when needed, but not by
the request itself. so, no caching proxy needed. no outdated data served.
i consider caching as a rather dirty work-around for problems in the app.

there's code highlighting. markdown support.

no browser side authoring, for now. text only.

## use

the recommended way is to set up your own blog like this:

    Blog = require 'colbo'
    blog = new Blog articles: __dirname + '/my_articles'
    blog.on 'ready', ->
      blog.app.listen 3000

## license

MIT license. do what you want. commercial use or whatever is okay.

## roadmap

spdy support. make if faster. a command line client? more formats.
images, cropping, caching, s3, coffee client side...

better error messages, i.e. when a template is not found.

## what else?

talk to the author via strathausen@gmail.com - cto of upcload.com
