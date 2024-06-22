#!/bin/sh

set -eu

export GIT_CEILING_DIRECTORIES="/github/workspace"

# Generate a temporary key for abuild
mkdir "$GITHUB_WORKSPACE"/.abuild
echo "$GITHUB_WORKSPACE/key" | abuild-keygen
echo PACKAGER_PRIVKEY="$GITHUB_WORKSPACE/key" > "$HOME"/.abuild/abuild.conf

cp "$GITHUB_WORKSPACE/key.pub" /etc/apk/keys

cd "$GITHUB_WORKSPACE/$INPUT_PACKAGE_PATH"

# Update the package version
sed -i "s/pkgver=.*/pkgver=$INPUT_RELEASE_VERSION/g" APKBUILD

# Reset pkgrel for the new version
sed -i "s/pkgrel=.*/pkgrel=0/g" APKBUILD

# Build the package
abuild -F checksum && abuild -F -r
