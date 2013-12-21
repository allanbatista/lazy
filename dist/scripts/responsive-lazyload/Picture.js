(function() {
  define(['dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/dom-attr', 'dojo/dom-construct', 'dojox/collections/Dictionary', 'dojo/_base/html', 'dojo/dom-geometry', 'dojo/on', 'dojo/topic'], function(declare, query, array, attr, construct, Dictionary, html, geometry, _on, topic) {
    var create_render, formater_picture_to_array, get_alt, get_current_media, get_information_image, update_render;
    formater_picture_to_array = function(node) {
      var dictionary;
      dictionary = new Dictionary();
      array.forEach(query('[data-lazy-src]', node), function(value) {
        var info;
        info = get_information_image(value);
        return dictionary.add(info.key, info.info);
      });
      return dictionary;
    };
    get_information_image = function(image) {
      var chave, height, source, width;
      chave = attr.get(image, 'data-lazy-media');
      source = attr.get(image, 'data-lazy-src');
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
      var render;
      render = query('img[data-lazy="render"]', node);
      if (render.length === 0) {
        render = construct.create('img');
        attr.set(render, 'data-lazy', "render");
        attr.set(render, 'alt', alt);
        construct.place(render, node);
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
    update_render = function(render, info) {
      attr.set(render, 'src', info.src);
      attr.set(render, 'width', info.width);
      attr.set(render, 'height', info.height);
      return render;
    };
    get_alt = function(node) {
      return attr.get(node, 'data-lazy-alt');
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
      getPosition: function() {
        return html.coords(this._node).t;
      },
      render: function() {
        var info, position, scrollTop, that, top;
        that = this;
        scrollTop = window.scrollY;
        top = scrollTop + window.innerHeight;
        info = this._picture_list.item(get_current_media(this._picture_list));
        if (info.src === this._current_url) {
          return this;
        }
        position = this.getPosition();
        if (position >= scrollTop - this._premonicao && position <= top + this._premonicao) {
          if (!this._render) {
            this._render = create_render(this._node, this._alt);
            _on(this._render, 'load', function() {
              return topic.publish('lazy/load/image', that);
            });
          }
          update_render(this._render, info);
          this._current_url = info.src;
        }
        return this;
      }
    });
  });

}).call(this);
