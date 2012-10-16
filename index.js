/*

Mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>
*/
var Mumpitz, async, connect, defaultTo, es, fs, intercept, mu, path, router, schnauzer, yamlmd, _;

require('coffee-script');

_ = require('underscore');

fs = require('fs');

path = require('path');

async = require('async');

es = require('event-stream');

connect = require('connect');

yamlmd = require('yamlmd');

schnauzer = require('schnauzer');

defaultTo = require('./plugins/defaultTo');

intercept = require('./plugins/intercept');

router = require('./plugins/router');

Mumpitz = (function() {

  module.exports = Mumpitz;

  function Mumpitz(properties) {
    var Blog;
    if (!properties.dir) {
      throw new Error('please specify "dir" where your articles are');
    }
    this.defaults = properties;
    this.blog = new (Blog = (function() {

      function Blog() {}

      return Blog;

    })());
    _.defaults(this.blog, properties);
    _.defaults(this.blog, {
      documents: [],
      template: __dirname + '/example/theme/article.hbs',
      app: connect()
    });
    this.router = router(this.blog.app);
  }

  Mumpitz.prototype.go = function(cb) {
    var EXTREG,
      _this = this;
    EXTREG = /\.(md|markdown|yamlmd)$/;
    return fs.readdir(this.blog.dir, function(err, docs) {
      if (err) return cb(err);
      return async.forEach(docs, (function(doc, cb) {
        var readStream, x;
        if (!EXTREG.test(doc)) return cb();
        x = {};
        readStream = fs.createReadStream(path.join(_this.blog.dir, doc));
        return readStream.pipe(yamlmd.stream()).pipe(defaultTo(_this.blog)).pipe(defaultTo({
          id: doc.replace(EXTREG, '')
        })).pipe(intercept(function(item) {
          return _this.blog.documents.push(item);
        })).pipe(intercept(function(item) {
          return x.url = item.id;
        })).pipe(schnauzer.stream()).pipe(_this.router(x)).on('end', function() {
          console.log('url:', x.url);
          return cb();
        });
      }), cb);
    });
  };

  return Mumpitz;

})();

if (!module.parent) {
  mu = new Mumpitz({
    dir: __dirname + '/example/articles',
    layout: __dirname + '/example/theme/layout.hbs'
  });
  mu.go(function() {
    console.error('done');
    return mu.blog.app.listen(3000);
  });
}
