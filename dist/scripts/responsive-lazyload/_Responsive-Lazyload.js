(function() {
  define(['lazy/Picture', 'dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'onx/on/buffer', 'onx/on/delay', 'dojo/topic'], function(Picture, declare, query, array, buffer, delay, topic) {
    return declare(null, {
      _pictures: [],
      constructor: function(imagens) {
        var that;
        that = this;
        array.forEach(imagens, function(value) {
          var picture;
          picture = new Picture(value);
          if (picture) {
            return that._pictures.push(picture);
          }
        });
        this.resize();
        return this;
      },
      render: function() {
        array.forEach(this._pictures, function(picture) {
          return picture.render();
        });
        return this;
      },
      resize: function() {
        var that;
        that = this;
        delay(window, 'load', function() {
          buffer(window, 'resize', function() {
            return that.render();
          }, 200);
          buffer(window, 'scroll', function() {
            return that.render();
          }, 200);
          that.render();
          return topic.publish('lazy/rendered', this);
        }, 200);
        return this;
      }
    });
  });

}).call(this);
