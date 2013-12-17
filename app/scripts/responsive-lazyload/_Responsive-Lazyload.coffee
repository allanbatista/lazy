define ['lazy/responsive-lazyload/Picture', 'dojo/_base/declare', 'dojo/query', 'dojo/_base/array', 'dojo/on'], (Picture, declare, query, array, _on) ->

    win = window

    return declare null, {
        # Amazena a lista de pictures disponiveis
        _pictures :  [],
        _rendered : false,
        _timer : null,
        _timer2 : null,
        constructor: ( imagens )->
            that = this
            array.forEach imagens, (value)->
                picture = new Picture(value)
                that._pictures.push picture if picture

            return this
        render: ()->
            array.forEach this._pictures, (picture)->
                picture.render()

            if !this._rendered
                this.resize() 
                this._rendered = true

        resize : ()->
            that = this
            _on win, 'resize', ()-> 

                clearTimeout _timer if _timer

                _timer = setTimeout ()->
                    that.render()
                , 200

            _on win, 'scroll', ()-> 

                clearTimeout _timer2 if _timer2

                _timer2 = setTimeout ()->
                    that.render()
                , 200
    }