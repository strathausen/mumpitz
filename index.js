/*

Mumpitz - all the blog engine you will ever need

@author Johann Philipp Strathausen <strathausen@gmail.com>
*/
var DOCEXT, EventEmitter, Mumpitz, Superwiser, async, defaultTo, es, fs, intercept, moment, path, schnauzer, superwiser, yamlmd, _,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

require('coffee-script');

_ = require('underscore');

fs = require('fs');

path = require('path');

async = require('async');

es = require('event-stream');

EventEmitter = require('events').EventEmitter;

moment = require('moment');

yamlmd = require('yamlmd');

schnauzer = require('schnauzer');

defaultTo = require('./plugins/defaultTo');

intercept = require('./plugins/intercept');

DOCEXT = /\.(md|markdown|yamlmd)$/;

Superwiser = (function(_super) {

  __extends(Superwiser, _super);

  function Superwiser() {
    Superwiser.__super__.constructor.apply(this, arguments);
  }

  return Superwiser;

})(EventEmitter);

superwiser = new Superwiser;

Mumpitz = (function() {

  module.exports = Mumpitz;

  function Mumpitz(properties) {
    var MumpitzBlog;
    if (!properties.dir) {
      throw new Error('please specify "dir" where your articles are');
    }
    this.defaults = properties;
    this.blog = new (MumpitzBlog = (function() {

      function MumpitzBlog() {}

      return MumpitzBlog;

    })());
    _.defaults(this.blog, properties);
    _.defaults(this.blog, {
      template: __dirname + '/example/theme/article.hbs'
    });
  }

  Mumpitz.prototype.documents = [];

  Mumpitz.prototype.go = function(cb) {
    var _this = this;
    return fs.readdir(this.blog.dir, function(err, docs) {
      if (err) return cb(err);
      return async.forEach(docs, (function(doc, cb) {
        var docName, outDir, readStream, writeStream;
        if (!DOCEXT.test(doc)) return cb();
        docName = doc.replace(DOCEXT, '');
        outDir = _this.blog.public || _this.blog.dir;
        readStream = fs.createReadStream(path.join(_this.blog.dir, doc));
        writeStream = fs.createWriteStream(path.join(outDir, "" + docName + ".html"));
        return readStream.pipe(es.join('')).pipe(yamlmd.stream()).pipe(defaultTo(_this.blog)).pipe(defaultTo({
          id: docName
        })).pipe(intercept(function(item) {
          return _this.documents.push(item);
        })).pipe(es.map(function(item, next) {
          cb();
          return superwiser.on('ready', function() {
            return next(null, item);
          });
        })).pipe(schnauzer.stream()).pipe(writeStream);
      }), function() {
        _this.documents = _.sortBy(_this.documents, function(doc) {
          var date;
          date = moment(doc.date);
          if (!date.isValid()) date = moment(doc.date, 'MMMM Do, YYYY');
          return -date.unix();
        });
        _this.documents.forEach(function(doc) {
          return doc.documents = _this.documents;
        });
        superwiser.emit('ready');
        return cb();
      });
    });
  };

  return Mumpitz;

})();
