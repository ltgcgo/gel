#!/bin/bash
rm -rf dist
mkdir -p dist
cp -Lr src/* dist/
ls -1 dist | while IFS= read -r variant; do
	if [ -f "./dist/${variant}/shared/etc/motd" ]; then
		sed -i "s/__VERSION__/$(cat build_version)/g" "./dist/${variant}/shared/etc/motd"
	fi
done
exit