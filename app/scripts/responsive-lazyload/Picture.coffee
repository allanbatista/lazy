define ['dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/dom-attr', 'dojo/dom-construct', 'dojox/collections/Dictionary', 'dojo/_base/html', 'dojo/dom-geometry', 'dojo/on', 'dojo/topic'], (declare, query, array, attr, construct, Dictionary, html, geometry, _on, topic)->

    formater_picture_to_array = ( node )->
        dictionary = new Dictionary()

        array.forEach query('[data-src]', node), ( value )->

            info = get_information_image(value)

            dictionary.add info.key, info.info

        return dictionary

    get_information_image = ( image )->
        chave = attr.get( image, 'data-media')
        source = attr.get( image, 'data-src')
        width = parseInt attr.get( image, 'data-width') || 0
        height = parseInt attr.get( image, 'data-height') || 0

        return {
            key: chave,
            info: {
                src: source,
                width: width,
                height: height
            }
        }

    create_render = ( node )->
        render = query 'img[data-lazy="render"]', node

        if( render.length == 0 )
            render = construct.create('img')
            attr.set render, 'data-lazy', "render"
            construct.place render, node

        return render

    get_current_media = (list)->
        media = ''

        array.forEach list.getKeyList(), (key)->
            media = key if matchMedia( key ).matches

        return media

    update_render = ( render, info )->
        attr.set render, 'src', info.src
        attr.set render, 'width', info.width
        attr.set render, 'height', info.height

        return render

    return declare null, {
        _node : null,
        _picture_list : null, # dojox.collections.Dictionary
        _render: null,
        _current_url : null,
        _premonicao: 0,
        constructor: (node_picture, fx)->
            this._node = node_picture
            this._picture_list = formater_picture_to_array(this._node)

            return this
        
        setPremonicao: ( px )-> # int
            this._premonicao = parseInt px if typeof px == 'number'

            return this

        getPositions: ()->
            position = html.coords(this._node)

            return {
                top: position.t + this._premonicao,
                bottom: position.t - this._premonicao
            }

        render : ()->
            that = this
            scrollTop = document.body.scrollTop
            top = scrollTop + window.innerHeight
            info = this._picture_list.item( get_current_media(this._picture_list) )

            if info.src == this._current_url
                return this

            position = this.getPositions()

            if position.top + info.height >= scrollTop && position.bottom <= top
                if !this._render
                    this._render = create_render(this._node) 
                    _on this._render, 'load', ()->
                        topic.publish('lazy/load/image', that)
                
                update_render( this._render, info )
                this._current_url = info.src

            return this
        
    }