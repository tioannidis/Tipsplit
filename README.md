# Tipsplit

A simple, free and open-source tip calculator for Android.

Enter the bill amount, pick a tip percentage (10/15/18/20/25% or a custom
value), choose how many people split the bill, and optionally round the
total up to the next whole dollar. Tipsplit shows the tip amount, the
total, and the amount per person.

## Features

- Preset tip percentages (10%, 15%, 18%, 20%, 25%) plus a custom tip value
- Split the bill across any number of people
- "Round Up to Next Dollar" mode
- No ads, no tracking, no network access, no special permissions

## Building

Tipsplit is a [Flutter](https://flutter.dev) app.

```sh
flutter pub get
flutter create --platforms=android --org io.github.tioannidis .
flutter test
flutter build apk --release
```

The first command fetches dependencies, the second generates the Android
platform folder (not checked in, see `.gitignore`), the third runs the
unit tests, and the last produces the release APK.

## F-Droid

Tipsplit follows the [F-Droid Inclusion Policy](https://f-droid.org/docs/Inclusion_Policy/):

- Licensed under [GPL-3.0](LICENSE)
- Only free-software dependencies (Flutter SDK, `intl`)
- No proprietary binaries, trackers, or non-free network services
- Buildable from source with a reproducible release build

App store metadata lives in [`fastlane/metadata/android/`](fastlane/metadata/android/).

## Contributing

Contributions are welcome. By contributing you agree that your
contributions are licensed under the GPL-3.0 license of this project.
