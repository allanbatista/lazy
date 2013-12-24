define ['lazy/_Responsive-Lazyload', 'dojo/query'], (ResponsiveLazyload, query)->
    imagens = query( 'picture[data-lazy]' )

    responsive = new ResponsiveLazyload()

    responsive.add(imagens).resize()

    return null
