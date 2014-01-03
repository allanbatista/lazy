(function() {
  define(['dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/dom-attr', 'dojo/dom-construct', 'dojox/collections/Dictionary', 'dojo/window', 'dojo/dom-geometry', 'dojo/on', 'dojo/topic'], function(declare, query, array, attr, construct, Dictionary, win, geometry, _on, topic) {
    var create_media, create_render, formater_picture_to_array, get_alt, get_current_media, get_information_image, image_x64, node_is_on_the_screen, update_render, w;
    image_x64 = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==';
    w = window;
    create_media = function(min, max) {
      var media_max, media_min;
      if (min) {
        media_min = '(min-width:' + min + 'px)';
      }
      if (max) {
        media_max = '(max-width:' + max + 'px)';
      }
      if (media_min && media_max) {
        return media_min + ' and ' + media_max;
      }
      return media_min || media_max || '';
    };
    formater_picture_to_array = function(node) {
      var base_url, dictionary;
      dictionary = new Dictionary();
      base_url = attr.get(node, 'data-lazy-base');
      array.forEach(query('[data-lazy-src]', node), function(value) {
        var info;
        if (base_url) {
          info = get_information_image(value, base_url);
        } else {
          info = get_information_image(value);
        }
        return dictionary.add(info.key, info.info);
      });
      return dictionary;
    };
    get_information_image = function(image, base_url) {
      var chave, data_max, data_min, height, source, width;
      data_min = attr.get(image, 'data-lazy-min');
      data_max = attr.get(image, 'data-lazy-max');
      chave = attr.get(image, 'data-lazy-media') || create_media(data_min, data_max);
      source = attr.get(image, 'data-lazy-src');
      if (base_url) {
        source = base_url + source;
      }
      width = parseInt(attr.get(image, 'data-lazy-width') || 0);
      height = parseInt(attr.get(image, 'data-lazy-height') || 0);
      return {
        key: chave,
        info: {
          src: source,
          width: width,
          height: height
        }
      };
    };
    create_render = function(node, alt) {
      var render, that;
      that = this;
      render = query('img[data-lazy="render"]', node);
      if (render.length === 0) {
        render = construct.create('img');
        attr.set(render, 'data-lazy', "render");
        attr.set(render, 'alt', alt);
        attr.set(render, 'src', image_x64);
        construct.place(render, node);
        _on(render, 'load', function() {
          return topic.publish('lazy/load/image', that);
        });
      }
      return render;
    };
    get_current_media = function(list) {
      var media;
      media = '';
      array.forEach(list.getKeyList(), function(key) {
        if (matchMedia(key).matches) {
          return media = key;
        }
      });
      return media;
    };
    update_render = function(render, info, without_src) {
      if (!without_src) {
        attr.set(render, 'src', info.src);
      }
      attr.set(render, 'width', info.width);
      attr.set(render, 'height', info.height);
      return render;
    };
    get_alt = function(node) {
      return attr.get(node, 'data-lazy-alt');
    };
    node_is_on_the_screen = function(node) {
      var position, windowBox;
      windowBox = win.getBox();
      position = geometry.position(node, true);
      return position.y + position.h >= windowBox.t && windowBox.t + windowBox.h > position.y;
    };
    return declare(null, {
      _node: null,
      _picture_list: null,
      _render: null,
      _current_url: null,
      _premonicao: 0,
      _alt: '',
      constructor: function(node_picture, fx) {
        this._node = node_picture;
        this._picture_list = formater_picture_to_array(this._node);
        this._alt = get_alt(node_picture);
        return this;
      },
      setPremonicao: function(px) {
        if (typeof px === 'number') {
          this._premonicao = parseInt(px);
        }
        return this;
      },
      render: function() {
        var info, that;
        that = this;
        info = this._picture_list.item(get_current_media(this._picture_list));
        if (info.src === this._current_url) {
          return this;
        }
        if (!this._render) {
          this._render = create_render(this._node, this._alt);
        }
        update_render(this._render, info, true);
        if (node_is_on_the_screen(this._render)) {
          update_render(this._render, info);
          this._current_url = info.src;
        }
        return this;
      }
    });
  });

}).call(this);
