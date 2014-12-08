etlmodexep
==========

_etlmodexep_ stands for _ET:Legacy mod executable patcher_. This tool patches some binaries from buggy well-known mods, allowing them to be hosted by ET:Legacy. The name is inspired by the [v200exep](http://www.ticalc.org/archives/files/fileinfo/247/24753.html) tool.

_etlmodexep_ knows how to patch _TrueCombat:Close Quarters Battle_ and _TrueCombat:Elite_ mods (see the [TrueCombat website](http://truecombatelite.com/) for more information about these mods).

Usage
-----

If mods are installed in standard ET:Legacy user directory, you can use the _cqbtest_ and _tcetest_ alias like that:

```
./etlmodexep.sh cqbtest
Working on file “/home/luser/.etlegacy/cqbtest/qagame.mp.i386.so”.
Binary file from “TrueCombat:Close Quarters Battle” recognized.
File will be patched, continue? (Y/n) 
File successfully patched.
File successfully overwriten by patched one.
```

Or you can pass a full path like that:


```
./etlmodexep.sh /home/luser/.etlegacy/tcetest/qagame.mp.i386.so
Working on file “/home/luser/.etlegacy/tcetest/qagame.mp.i386.so”.
Binary file from “TrueCombat:Elite” recognized.
File will be patched, continue? (Y/n)
File successfully patched.
File successfully overwriten by patched one.
```

See the complete help with `./etlmodexep.sh --help` for more information.

Warning
-------

Theses patches must be use with ET:Legacy servers only. Never use them for ET:Legacy clients. If you want to host a game and play on the same computer, launch the dedicated server with another user.

Author
------

Thomas Debesse <dev@illwieckz.net>

Copyright
---------

This script is distributed under the highly permissive and laconic [ISC License](COPYING.md).
