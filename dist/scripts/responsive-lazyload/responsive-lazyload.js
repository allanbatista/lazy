(function() {
  define(['lazy/_Responsive-Lazyload', 'dojo/query'], function(ResponsiveLazyload, query) {
    var imagens, responsive;
    imagens = query('lazy, [data-lazy]');
    responsive = new ResponsiveLazyload();
    responsive.add(imagens).resize();
    return null;
  });

}).call(this);
