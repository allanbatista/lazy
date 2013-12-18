define ['lazy/responsive-lazyload/Picture', 'dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'onx/on/buffer', 'onx/on/delay', 'dojo/topic'], (Picture, declare, query, array, buffer, delay, topic) ->

    win = window

    return declare null, {
        _pictures :  [], # Amazena a lista de pictures disponiveis
        
        constructor: ( imagens )->
            that = this

            array.forEach imagens, (value)->
                picture = new Picture(value)
                that._pictures.push picture if picture

            # this.render()
            this.resize()

            return this
        
        render: ()->
            array.forEach this._pictures, (picture)->
                picture.render()

            return this

        resize : ()->
            that = this

            delay win, 'load', ()->
                buffer win, 'resize', ()->
                    that.render()
                , 200

                buffer win, 'scroll', ()-> 
                    that.render()
                , 200

                that.render()
                topic.publish('lazy/rendered', this)
            , 200


            return this
    }