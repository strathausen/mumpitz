/*

mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>
*/
var Mumpitz, async, schnauzer, yamlmd, _;

require('coffee-script');

_ = require('underscore');

async = require('async');

yamlmd = require('yamlmd');

schnauzer = require('schnauzer');

Mumpitz = (function() {

  module.exports = Mumpitz;

  function Mumpitz(properties) {
    var Blog;
    if (!properties.dir) {
      throw new Error('please specify "dir" where your articles are');
    }
    this.blog = new (Blog = (function() {

      function Blog() {}

      return Blog;

    })());
    _.defaults(this.blog, properties);
    _.defaults(this.blog, {
      documents: [],
      template: __dirname + '/theme/article.mustache'
    });
  }

  Mumpitz.prototype.go = function(cb) {
    return async.series(plugins.map(function(p) {
      return async.apply(p, blog);
    }), cb);
  };

  return Mumpitz;

})();
