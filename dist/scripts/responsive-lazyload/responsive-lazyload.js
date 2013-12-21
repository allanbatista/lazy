(function() {
  define(['lazy/_Responsive-Lazyload', 'dojo/query'], function(ResponsiveLazyload, query) {
    var imagens;
    imagens = query('picture[data-lazy]');
    if (imagens) {
      return new ResponsiveLazyload(imagens);
    }
    return null;
  });

}).call(this);
