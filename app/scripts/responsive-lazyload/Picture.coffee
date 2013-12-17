define ['dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/dom-attr', 'dojo/dom-construct', 'dojox/collections/Dictionary', 'dojo/_base/html', 'dojo/dom-geometry'], (declare, query, array, attr, construct, Dictionary, html, geometry)->

    body = query('body')[0]

    formater_picture_to_array = ( node )->
        dictionary = new Dictionary()

        array.forEach query('[data-src]', node), (value, key)->
            dictionary.add(attr.get(value, 'data-media'), {
                src: attr.get(value, 'data-src'),
                width: parseInt(attr.get(value, 'data-width')),
                height: parseInt(attr.get(value, 'data-height'))
            })

        return dictionary

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

    return declare null, {
        _node : null,
        _picture_list : null, # dojox.collections.Dictionary
        _render: null,
        _current_url : null,
        constructor: (node_picture)->
            this._node = node_picture
            this._picture_list = formater_picture_to_array(this._node)
            this._render = create_render(node_picture)
            return this
        render : ()->

            this.currentMedia = get_current_media(this._picture_list)
            image = this._picture_list.item(this.currentMedia)

            if image.src == this._current_url
                return this

            position = html.coords(this._render)
            top = window.scrollY + window.innerHeight
            
            if image && position.t >= (window.scrollY - position.h) && position.t <= top
                attr.set this._render, 'src', image.src
                attr.set this._render, 'width', image.width if image.width
                attr.set this._render, 'height', image.height if image.height
                this._current_url = image.src

            return this
        
    }