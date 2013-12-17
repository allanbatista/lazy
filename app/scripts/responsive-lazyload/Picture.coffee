define ['dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/dom-attr', 'dojo/dom-construct', 'dojox/collections/Dictionary'], (declare, query, array, attr, construct, Dictionary)->

    formater_picture_to_array = ( node )->
        dictionary = new Dictionary()

        array.forEach query('[data-src]', node), (value, key)->
            dictionary.add(attr.get(value, 'data-media'), attr.get(value, 'data-src'))

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
        constructor: (node_picture)->
            this._node = node_picture
            this._picture_list = formater_picture_to_array(this._node)
            this._render = create_render(node_picture)
            return this
        render : ()->
            this.currentMedia = get_current_media(this._picture_list)
            src = this._picture_list.item(this.currentMedia)
            attr.set this._render, 'src', src

            return this
        
    }