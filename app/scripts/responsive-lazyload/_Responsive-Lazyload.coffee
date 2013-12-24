define ['lazy/Picture', 'dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'onx/on/buffer', 'onx/on/delay', 'dojo/topic'], (Picture, declare, query, array, buffer, delay, topic) ->

    return declare null, {
        _pictures :  [], # Amazena a lista de pictures disponiveis
        _resized  : false,

        constructor: ( imagens, resize )-> # Array of nodes
            that = this

            this.add(imagens) if imagens
            this.resize() if resize

            return this

        render: ()->
            array.forEach this._pictures, (picture)->
                picture.render()

            return this

        resize : ()->
            that = this

            if _resized
                return this
            else
                delay window, 'load', ()->
                    buffer window, 'resize', ()->
                        that.render()
                    , 200

                    buffer window, 'scroll', ()->
                        that.render()
                    , 200

                    that.render()
                    topic.publish('lazy/rendered', this)
                , 200
                _resized = true

            this.render()

            return this

        add : (images)-> # Array os nodes
            that = this

            array.forEach images, (value)->
                picture = new Picture(value)
                that._pictures.push picture

            return this
    }
