#!/bin/sh

echo ""
echo "/---------------------------------------\\"
echo "|     - OMORI PATCH TOOL FOR INTEL -    |"
echo "\\---------------------------------------/"
echo ""

OMORI=~/Library/Application\ Support/Steam/steamapps/common/OMORI # Directory of Omori

if [ ! -d "${OMORI}" ]; then # Looks for Omori
  echo "[!!] Please install OMORI using Steam before using this tool.";
  exit 1;
fi;

echo "Backing up original OMORI copy.."
if [ -f "${OMORI}.original" ]; then
  rm -rf "${OMORI}.original" # Removes original backup
fi;
cp -r "${OMORI}" "${OMORI}.original"; # Copies files to backup folder

TMPFOLDER=$(mktemp -d /tmp/omori-patch.XXXXXX) || exit 1
cd "$TMPFOLDER"; # Creates temporary folder

mv "${OMORI}" "./OMORI.original"; # Moves game files to temporary folder

# Downloads required files
echo "Downloading nwjs for Intel.."
curl -#L -o nwjs.zip https://dl.node-webkit.org/v0.103.1/nwjs-v0.103.1-osx-x64.zip
echo "Downloading node polyfill patch.."
curl -#L -o node-polyfill-patch.js https://github.com/BasilGunderson/omori-apple-silicon-and-intel/releases/download/v1.0.0/node-polyfill-patch.js
echo "Downloading greenworks patches for Intel.."
curl -#L -o greenworks.js https://github.com/BasilGunderson/omori-apple-silicon-and-intel/releases/download/v1.0.0/greenworks.js
curl -#L -o greenworks-osx64.node https://github.com/BasilGunderson/omori-apple-silicon-and-intel/releases/download/v1.0.0/greenworks-osx64.node
echo "Downloading steamworks api.."
curl -#L -o steam.zip https://github.com/BasilGunderson/omori-apple-silicon-and-intel/releases/download/v1.0.0/steam.zip

# Extracts specific archives
echo "Extracting nwjs.."
unzip -q nwjs.zip
echo "Extracting steamworks.."
unzip -qq steam.zip

# Patches game by moving files
echo "Patching game.."
mv "./nwjs-v0.103.1-osx-x64/nwjs.app" "./OMORI"
mv -f ./OMORI.original/Contents/Resources/app.nw ./OMORI/Contents/Resources/
mv -f ./OMORI.original/Contents/Resources/app.icns ./OMORI/Contents/Resources/
mv -f ./node-polyfill-patch.js ./OMORI/Contents/Resources/app.nw/js/libs/
mv -f ./greenworks.js ./OMORI/Contents/Resources/app.nw/js/libs/
mv -f ./greenworks-osx64.node ./OMORI/Contents/Resources/app.nw/js/libs/
mv -f ./steam/libsteam_api.dylib ./OMORI/Contents/Resources/app.nw/js/libs/
mv -f ./steam/libsdkencryptedappticket.dylib ./OMORI/Contents/Resources/app.nw/js/libs/

echo "Finished. Moving patched game back to original location.."
mv "./OMORI" "${OMORI}"

echo ""
echo "Done! Launch OMORI through Steam."
echo "Note that if you update OMORI or check the integrity of the game files, you'll need to reapply the patch."
echo ""
echo ""

