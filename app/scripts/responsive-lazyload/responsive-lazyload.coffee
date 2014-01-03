define ['lazy/_Responsive-Lazyload', 'dojo/query'], (ResponsiveLazyload, query)->
    imagens = query( 'lazy, [data-lazy]' )

    responsive = new ResponsiveLazyload()

    responsive.add(imagens).resize()

    return null
