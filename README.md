With libxml2 2.9.4 (included in [Ubuntu 18.04 LTS](https://packages.ubuntu.com/bionic/libxml2)), the Graby’s WordPress lazy-loading noscript cleaner is unable to remove the second image in the noscript text:

```html
<p><img data-lazyloaded="1" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI2MzkiIGhlaWdodD0iNDA4IiB2aWV3Qm94PSIwIDAgNjM5IDQwOCI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0iI2NmZDRkYiIvPjwvc3ZnPg==" class="aligncenter size-full wp-image-32079" data-src="https://uxmovement.com/wp-content/uploads/2020/11/layout-scalebadge.png" alt="" width="639" height="408" /><noscript><img class="aligncenter size-full wp-image-32079" src="https://uxmovement.com/wp-content/uploads/2020/11/layout-scalebadge.png" alt="" width="639" height="408" /></noscript></p>
```

is turned into:

```html
<p><img data-lazyloaded="1" src="https://uxmovement.com/wp-content/uploads/2020/11/layout-scalebadge.png" class="aligncenter size-full wp-image-32079" alt="" width="639" height="408" /></p><noscript>
<p><img class="aligncenter size-full wp-image-32079" src="https://uxmovement.com/wp-content/uploads/2020/11/layout-scalebadge.png" alt="" width="639" height="408" /></p>
```

It works fine with libxml2 2.9.10 in later versions of Ubuntu.

You can reproduce this by running 

```ShellSession
$ composer install
$ php test.php
```

on system with libxml2 2.9.4, or if you have [Nix](https://nixos.org/download.html) (will re-compile PHP against that libxml version):

```ShellSession
$ $nix-shell --run 'composer install; php test.php'
```

See <https://github.com/fossar/selfoss/issues/1230> for more details.
