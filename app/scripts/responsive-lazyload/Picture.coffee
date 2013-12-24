define ['dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/dom-attr', 'dojo/dom-construct', 'dojox/collections/Dictionary', 'dojo/window', 'dojo/dom-geometry', 'dojo/on', 'dojo/topic'], (declare, query, array, attr, construct, Dictionary, win, geometry, _on, topic)->

    image_x64 = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='
    w = window

    formater_picture_to_array = ( node )->
        dictionary = new Dictionary()

        array.forEach query('[data-lazy-src]', node), ( value )->

            info = get_information_image(value)

            dictionary.add info.key, info.info

        return dictionary

    get_information_image = ( image )->
        chave = attr.get( image, 'data-lazy-media')
        source = attr.get( image, 'data-lazy-src')
        width = parseInt attr.get( image, 'data-lazy-width') || 0
        height = parseInt attr.get( image, 'data-lazy-height') || 0

        return {
            key: chave,
            info: {
                src: source,
                width: width,
                height: height
            }
        }

    create_render = ( node , alt )->
        that = this
        render = query 'img[data-lazy="render"]', node

        if( render.length == 0 )
            render = construct.create('img')
            attr.set render, 'data-lazy', "render"
            attr.set render, 'alt', alt
            attr.set render, 'src', image_x64
            construct.place render, node

            # Adiciona evento de load da imagen
            _on render, 'load', ()->
                topic.publish('lazy/load/image', that)

        return render

    get_current_media = (list)->
        media = ''

        array.forEach list.getKeyList(), (key)->
            media = key if matchMedia( key ).matches

        return media

    update_render = ( render, info, without_src )->
        attr.set render, 'src', info.src if !without_src

        attr.set render, 'width', info.width
        attr.set render, 'height', info.height

        return render

    get_alt = (node)->
        return attr.get node, 'data-lazy-alt'

    node_is_on_the_screen = (node)->
        windowBox = win.getBox()
        position = geometry.position(node, true)

        return position.y + position.h >= windowBox.t && windowBox.t + windowBox.h > position.y


    return declare null, {
        _node : null,
        _picture_list : null, # dojox.collections.Dictionary
        _render: null, #node
        _current_url : null,
        _premonicao: 0, # Este atributo diz a quantos px para baixo ou para cima deve-se prever as imagens.
        _alt: '', # default alt

        constructor: (node_picture, fx)->
            this._node = node_picture
            this._picture_list = formater_picture_to_array(this._node)
            this._alt = get_alt node_picture

            return this

        setPremonicao: ( px )-> # int
            this._premonicao = parseInt px if typeof px == 'number'

            return this

        render : ()->
            that = this
            info = this._picture_list.item( get_current_media(this._picture_list) )

            if info.src == this._current_url
                return this

            if !this._render
                this._render = create_render(this._node, this._alt)

            update_render( this._render, info, true )

            if node_is_on_the_screen(this._render)
                update_render( this._render, info )
                this._current_url = info.src

            return this

    }
