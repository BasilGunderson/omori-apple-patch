# Technical Writeup on the OMORI Mac arm64/x64 patch

## Quick outline
* Repackage omori into nw.js [v0.103.1](https://dl.nwjs.io/v0.103.1/)
* Update steamworks to 1.62 (`libsteam_api.dylib` and `libsdkencryptedappticket.dylib`)
* Patch [greenworks](https://github.com/greenheartgames/greenworks) to compile to arm64 and x64 with steamworks 1.62
* Polyfill node (written (by others) in node.js v20.1.0) included with nw.js v0.103.1 to restore deprecated support for writing raw number types to files causing [a bug](https://github.com/SnowpMakes/omori-apple-silicon/issues/1).

