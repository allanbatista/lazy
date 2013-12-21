define ['lazy/_Responsive-Lazyload', 'dojo/query'], (ResponsiveLazyload, query)->
    imagens = query( 'picture[data-lazy]' )

    return new ResponsiveLazyload( imagens ) if imagens

    return null
