# Responsive Lazyload Image

O responsive lazyload image, é um componente para dojotoolkit que pemite carregar imagens sobre demanda e com a imagem para determinada resolução.

Com isso, é possível ter sites carregando muitas vezes mais rápido com a imagem correta, nada de redimencionar! :)

## Utilizando

### HTML

    <picture data-lazy-alt="Alt da imagem" data-lazy>
       <source data-lazy-media="(min-width: 320px)"  data-lazy-src="http://placehold.it/320x480"  data-lazy-width="320"  data-lazy-height="480">
       <source data-lazy-media="(min-width: 768px)"  data-lazy-src="http://placehold.it/768x600/00ffff"
       <noscript>
           <img src="http://placehold.it/1200x600" alt="Alt da imagem" width="1200" height="600">
       </noscript>
    </picture>

#### Wrapper da Imagem
    
    <picture data-lazy-alt="Alt da imagem" data-lazy></picture>

#### Fallback (Quando não existir javascript disponível)

    <noscript>
        <img src="http://placehold.it/1200x600" alt="Alt da imagem" width="1200" height="600">
    </noscript>

## Imagens

É possível adicionar qualquer quantidade de imagens, desde que siga um padrãozinho:

    <source data-lazy-media="(min-width: 320px)"  data-lazy-src="http://placehold.it/320x480"  data-lazy-width="320"  data-lazy-height="480">

- data-lazy-media : Este é o parâmetro de media querie
- data-lazy-src : Imagem para este media
- data-lazy-width: Largura da imagem, isso melhora muito a experiência do usuário
- data-lazy-height: Altura da imagem, isso melhora muito a experiência do usuário

### Javascript ( Importando o componente )

#### DojoConfig:

    var dojoConfig = {
        packages: [{
            name: 'lazy',
            location: '/bower_components/lazy/dist/scripts/responsive-lazyload'
        }, {
            name: 'onx',
            location: '/bower_components/onx/src'
        }, {
            name: 'mout',
            location: '/bower_components/mout/src'
        }]
    }

#### Require
    require('lazy/responsive-lazyload');

#### bower.json
    "dependencies": {
        "dojo": "~1.9",
        "dojox": "~1.9",
        "dijit": "~1.9",
        "matchmedia": "~0.1.0",
        "onx": "git://github.com/eduardo-matos/onx.git",
        "mout": "~0.7.1"
    }

#### bower install
    $ bower install

## Dúvidas?

Fala comigo!
email: allan@allanbatista.com.br
