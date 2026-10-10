#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
URL="https://installer.rootapp.com/installer/Linux/X64/Root.AppImage"
echo "Fetching latest Root AppImage from $URL ..."
JSON=$(nix store prefetch-file --json "$URL")
HASH=$(echo "$JSON" | python3 -c "import json, sys; print(json.load(sys.stdin)['hash'])")
STORE_PATH=$(echo "$JSON" | python3 -c "import json, sys; print(json.load(sys.stdin)['storePath'])")
VERSION=$(7z x -so "$STORE_PATH" Root.desktop 2>/dev/null | grep '^X-AppImage-Version=' | cut -d= -f2)
if [ -z "$VERSION" ]; then
  echo "Failed to read X-AppImage-Version from Root.desktop" >&2
  exit 1
fi
sed -i -E "s/version = \"[^\"]+\";/version = \"${VERSION}\";/" package.nix
sed -i -E "s|hash = \"sha256-[A-Za-z0-9+/=]+\";|hash = \"${HASH}\";|" package.nix
echo "Updated to ${VERSION} ${HASH}"
echo "Rebuild to apply: nix run . or nixos-rebuild with the overlay"
