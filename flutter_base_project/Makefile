# Makefile for jean_inspection Flutter project
# 
# Targets:
#   clean: Cleans the Flutter project, fetches dependencies, rebuilds generated files, and updates localization files.
#   build: Rebuilds generated files and updates localization files.
#   reset_pod: Runs the iOS pod reset script.
#   release_sit: Builds and releases the iOS app for SIT environment using Fastlane.
#   release_uta: Builds and releases the iOS app for UTA environment using Fastlane.
#   release_prod: Builds and releases the iOS app for production using Fastlane.
#   release_Android: Builds and releases the Android APK using Fastlane.
#   changelog: Generates the project changelog using git-cliff.
#   generate_localization: Generates localization keys and files from translation assets.
#   openapi: Regenerates Dart API client from OpenAPI spec and rebuilds generated files.

clean:
	@echo "Cleaning"
	@flutter clean
	@flutter pub get
	@flutter pub run build_runner build --delete-conflicting-outputs
	@flutter gen-l10n

build_runner:
	@flutter pub run build_runner build --delete-conflicting-outputs

reset_pod:
	@./reset_pod_ios.sh

release_sit:
	@cd ios && fastlane sit

release_uta:
	@cd ios && fastlane uta

release_prod:
	@cd ios && fastlane prod

release_Android:
	@cd android && fastlane build_apk

changelog:
	@git cliff -c cliff_md.toml -o CHANGELOG.md

generate_localization:
	@flutter pub run easy_localization:generate -f keys --source-dir 'assets/translations/' --output-dir 'lib/app' --output-file 'locale_keys.g.dart'

reset_pod:
	@./reset_pod_ios.sh

openapi:
	@rm -rf open_api/* && cd open_api && openapi-generator generate -i https://jeancrm.webtech888.com/swagger/v1/swagger.json -g dart-dio && flutter pub run build_runner build --delete-conflicting-outputs

# Deploys the web application to Firebase Hosting under the site 'shindanotify-dacd6'.
# Usage: make deployweb
deployweb:
	@firebase deploy --only hosting:shindanotify-dacd6