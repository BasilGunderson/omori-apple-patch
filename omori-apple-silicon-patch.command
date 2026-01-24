#!/bin/sh


echo ""
echo "/-------------------------------------------\\"
echo "|     - OMORI APPLE SILICON PATCH TOOL -    |"
echo "\\-------------------------------------------/"
echo ""


# Directory of Omori
OMORI=~/Library/Application\ Support/Steam/steamapps/common/OMORI


# Looks for Omori
if [ ! -d "${OMORI}" ] || [ ! -d "${OMORI}/OMORI.app" ]; then
  echo "[!!] Please install OMORI using Steam before using this tool."
  exit 1
fi


# Copies files to backup folder
echo "Backing up original OMORI copy.."
if [ -f "${OMORI}/OMORI.original.app" ]; then
  rm -rf "${OMORI}/OMORI.original.app" # Removes original backup
fi
cp -r "${OMORI}/OMORI.app" "${OMORI}/OMORI.original.app"


# Creates temporary folder
TMPFOLDER=$(mktemp -d /tmp/omori-patch.XXXXXX) || exit 1
cd "$TMPFOLDER"

# Moves game files to temporary folder
mv "${OMORI}/OMORI.app" "./OMORI.original.app"


# Downloads required files with error checks
echo "Downloading nwjs.."
curl -#L -o nwjs.zip https://dl.node-webkit.org/v0.103.1/nwjs-v0.103.1-osx-arm64.zip
if [ $? -ne 0 ]; then
  echo "[!!] Failed to download nwjs. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

echo "Downloading node polyfill patch.."
curl -#L -o node-polyfill-patch.js https://github.com/BasilGunderson/omori-apple-patch/releases/download/v1.0.0/node-polyfill-patch.js
if [ $? -ne 0 ]; then
  echo "[!!] Failed to download node polyfill patch. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

echo "Downloading greenworks patches.."
curl -#L -o greenworks.js https://github.com/BasilGunderson/omori-apple-patch/releases/download/v1.0.0/greenworks.js
curl -#L -o greenworks-osxarm64.node https://github.com/BasilGunderson/omori-apple-patch/releases/download/v1.0.0/greenworks-osxarm64.node
if [ $? -ne 0 ]; then
  echo "[!!] Failed to download greenworks patches. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

echo "Downloading steamworks api.."
curl -#L -o steam.zip https://github.com/BasilGunderson/omori-apple-patch/releases/download/v1.0.0/steam.zip
if [ $? -ne 0 ]; then
  echo "[!!] Failed to download steamworks api. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi


# Extracts specific archives with error checks
echo "Extracting nwjs.."
unzip -q nwjs.zip
if [ $? -ne 0 ]; then
  echo "[!!] Failed to extract nwjs.zip. The file may be corrupted. Trying to re-download..."
  rm -f nwjs.zip
  curl -#L -o nwjs.zip https://dl.node-webkit.org/v0.103.1/nwjs-v0.103.1-osx-arm64.zip
  if [ $? -ne 0 ]; then
    echo "[!!] Failed to re-download nwjs. Restoring original game and exiting."
    mv "./OMORI.original.app" "${OMORI}/OMORI.app"
    exit 1
  fi
  unzip -q nwjs.zip
  if [ $? -ne 0 ]; then
    echo "[!!] Failed to extract nwjs.zip again. Restoring original game and exiting."
    mv "./OMORI.original.app" "${OMORI}/OMORI.app"
    exit 1
  fi
fi

# Verify that the extraction created the expected directory
if [ ! -d "./nwjs-v0.103.1-osx-arm64" ]; then
  echo "[!!] Expected nwjs directory not found after extraction. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

if [ ! -d "./nwjs-v0.103.1-osx-arm64/nwjs.app" ]; then
  echo "[!!] Expected nwjs.app not found after extraction. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

echo "Extracting steamworks.."
unzip -qq steam.zip
if [ $? -ne 0 ]; then
  echo "[!!] Failed to extract steam.zip. The file may be corrupted. Trying to re-download..."
  rm -f steam.zip
  curl -#L -o steam.zip https://github.com/BasilGunderson/omori-apple-patch/releases/download/v1.0.0/steam.zip
  if [ $? -ne 0 ]; then
    echo "[!!] Failed to re-download steamworks api. Restoring original game and exiting."
    mv "./OMORI.original.app" "${OMORI}/OMORI.app"
    exit 1
  fi
  unzip -qq steam.zip
  if [ $? -ne 0 ]; then
    echo "[!!] Failed to extract steam.zip again. Restoring original game and exiting."
    mv "./OMORI.original.app" "${OMORI}/OMORI.app"
    exit 1
  fi
fi

if [ ! -d "./steam" ]; then
  echo "[!!] Expected steamworks directory not found after extraction. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

if [ ! "./steam/libsteam_api.dylib" ]; then
  echo "[!!] Expected libsteam_api.dylib not found after extraction. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

if [ ! "./steam/libsdkencryptedappticket.dylib" ]; then
  echo "[!!] Expected libsdkencryptedappticket.dylib not found after extraction. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi


# Patches game by moving files, with error checking for each mv command
echo "Patching game.."
mv "./nwjs-v0.103.1-osx-arm64/nwjs.app" "./OMORI.app"
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move nwjs.app. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./OMORI.original.app/Contents/Resources/app.nw ./OMORI.app/Contents/Resources/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move app.nw. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./OMORI.original.app/Contents/Resources/app.icns ./OMORI.app/Contents/Resources/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move app.icns. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./node-polyfill-patch.js ./OMORI.app/Contents/Resources/app.nw/js/libs/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move node-polyfill-patch.js. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./greenworks.js ./OMORI.app/Contents/Resources/app.nw/js/libs/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move greenworks.js. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./greenworks-osxarm64.node ./OMORI.app/Contents/Resources/app.nw/js/libs/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move greenworks-osxarm64.node. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./steam/libsteam_api.dylib ./OMORI.app/Contents/Resources/app.nw/js/libs/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move libsteam_api.dylib. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi

mv -f ./steam/libsdkencryptedappticket.dylib ./OMORI.app/Contents/Resources/app.nw/js/libs/
if [ $? -ne 0 ]; then
  echo "[!!] Failed to move libsdkencryptedappticket.dylib. Restoring original game and exiting."
  mv "./OMORI.original.app" "${OMORI}/OMORI.app"
  exit 1
fi


echo "Finished. Moving patched game back to original location.."
mv "./OMORI.app" "${OMORI}/OMORI.app"


echo ""
echo "Done! Launch OMORI through Steam."
echo "Note that if you update OMORI or check the integrity of the game files, you'll need to reapply the patch."
echo ""
echo ""

