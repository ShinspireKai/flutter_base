#!/bin/bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf ~/.pub-cache/hosted/pub.dartlang.org/
pod cache clean --all

cd ..
flutter clean
flutter pub get

cd ios
pod repo update
pod install

cd ..
flutter run