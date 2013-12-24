(function() {
  define(['lazy/Picture', 'dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'onx/on/buffer', 'onx/on/delay', 'dojo/topic'], function(Picture, declare, query, array, buffer, delay, topic) {
    return declare(null, {
      _pictures: [],
      _resized: false,
      constructor: function(imagens, resize) {
        var that;
        that = this;
        if (imagens) {
          this.add(imagens);
        }
        if (resize) {
          this.resize();
        }
        return this;
      },
      render: function() {
        array.forEach(this._pictures, function(picture) {
          return picture.render();
        });
        return this;
      },
      resize: function() {
        var that, _resized;
        that = this;
        if (_resized) {
          return this;
        } else {
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
          _resized = true;
        }
        this.render();
        return this;
      },
      add: function(images) {
        var that;
        that = this;
        array.forEach(images, function(value) {
          var picture;
          picture = new Picture(value);
          return that._pictures.push(picture);
        });
        return this;
      }
    });
  });

}).call(this);
