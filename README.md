# Mumpitz

The stream-punk of blog engines.

Untested pipe-based minimalistic html rendering.

All the power to the pipes!

## Usage

Here's how you would use it.

``` js
var Blog = require('mumpitz');
var blog = new Blog({
  dir: __dirname + '/articles'
});
blog.go(function(err) {
  if(err) {
    return console.log('Oh, there was an error:', err);
  }
  console.log('Done.');
});
```

Now all the yaml annotated markdown files in directory `articles` would be
compiled to HTML files in the same directory.  Of course, you can also
specify a differend directory to store the HTML files in.
See <a href="https://github.com/strathausen/blog">my blog</a> for a more
detailed example to see all the options in use.

## License

MIT, BSD, whatever.

## Roadmap

Tests, docs.

## What else?

Talk to the author via philipp@stratha.us
