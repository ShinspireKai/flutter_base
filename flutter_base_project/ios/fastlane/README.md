fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test_changelog

```sh
[bundle exec] fastlane ios test_changelog
```

Preview changelog for a specific env (env:SIT, env:UTA, env:PROD)

### ios sit

```sh
[bundle exec] fastlane ios sit
```

Build and push SIT build to TestFlight

### ios uta

```sh
[bundle exec] fastlane ios uta
```

Build and push UTA build to TestFlight

### ios prod

```sh
[bundle exec] fastlane ios prod
```

Build and push PROD build to TestFlight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
