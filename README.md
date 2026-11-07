# Tipsplit

**Calculate tips and split bills effortlessly**

Tipsplit is the ultimate tip calculator that makes dining out stress-free. Whether you're at a restaurant, bar, or café, calculate the perfect tip and split the bill among friends in seconds.

## Key Features

- **Instant Calculations** – Results update automatically as you type
- **Smart Tip Options** – Quick buttons for 10%, 15%, 18%, 20%, 25% or set your own custom percentage
- **Bill Splitting** – Easily divide the total among any number of people
- **Round Up Feature** – One-tap rounding to the nearest dollar for convenience
- **Clean Interface** – Large, easy-to-read numbers and intuitive design
- **Works Offline** – No internet connection required
- **Lightning Fast** – No loading times or "calculate" buttons needed

## How it works

1. Enter your bill amount
2. Select or customize your tip percentage
3. Add number of people (if splitting)
4. See instant results for tip amount, total, and cost per person

## Building

This is a Flutter app targeting Android.

```sh
flutter pub get
flutter test
flutter build apk --release
```

Signing for release builds is configured via standard Android signing; debug
signing is used as a placeholder in `android/app/build.gradle`.

## License

Copyright (C) Tipsplit contributors.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version. See [LICENSE](LICENSE).
