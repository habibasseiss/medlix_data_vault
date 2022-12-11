#!/bin/sh

dirs=("example1" "example2" "example3")

for dir in "${dirs[@]}"
do
    (
        cd "$dir" &&
        rm -rf build &&
        flutter clean &&
        flutter pub get &&
        cd ios && rm -rf Pods/ Podfile.lock && pod install --repo-update
    )
done
