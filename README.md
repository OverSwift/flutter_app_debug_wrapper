# appdebug

In-app debug overlay for Flutter: a draggable button that opens a log viewer (with details and sharing), backed by [loggy](https://pub.dev/packages/loggy).

## Usage

```dart
final logsPrinter = AppLogsLoggyPrinter();

Loggy.initLoggy(
  logPrinter: MultyDestinationLoggyPrinter(
    printers: [const PrettyPrinter(), logsPrinter],
  ),
);

// Wrap your app (typically only in debug builds):
DebugView(
  navigatorKey: navigatorKey, // the key of your app's Navigator
  showDebugViewButton: true,
  logsPrinter: logsPrinter,
  app: app,
)
```

A runnable demo lives in [`example/`](example/).

## Installation

```yaml
dependencies:
  appdebug:
    git:
      url: <repository-url>
```

## Sharing logs (`share_plus` setup)

The log viewer can export logs as a `.txt` file and open the system share sheet. This uses [`share_plus`](https://pub.dev/packages/share_plus) and [`path_provider`](https://pub.dev/packages/path_provider), which are pulled in automatically. You don't need to add them to your app's `pubspec.yaml` and you don't need to register anything in code.

### Requirements

These come from `share_plus` 13.x, so your host app must meet them:

| Requirement | Minimum |
| --- | --- |
| Flutter | >= 3.38.1 |
| Dart | >= 3.10.0 < 4.0.0 |
| iOS | >= 13.0 |
| macOS | >= 10.15 |
| Java | 17 |
| Kotlin | 2.2.0 |
| Android Gradle Plugin | >= 8.12.1 |
| Gradle wrapper | >= 8.13 |

### Platform notes

- **Android:** no manifest changes or permissions are needed. Logs are written to the app's temporary directory and shared via the system chooser.
- **iOS / macOS:** no `Info.plist` changes are needed. After adding the dependency, run `pod install` (Flutter does this on the next build). Set the iOS deployment target to 13.0 or higher (`platform :ios, '13.0'` in `ios/Podfile`).
- **iPad:** the share sheet is shown as a popover and needs an anchor rect. `appdebug` does not currently pass `sharePositionOrigin`, so sharing may fail or throw on iPad. Test on an iPad before relying on it there.
- **Web:** uses the Web Share API, which needs HTTPS and a browser that supports it. Otherwise `share_plus` falls back to downloading the file.
- **Windows:** file sharing works.
- **Linux:** sharing files is not supported by `share_plus`, so log export is unavailable.

### Troubleshooting

- *Build fails with a Gradle, Kotlin or Java version error:* upgrade your Android toolchain to the versions in the table above.
- *Nothing happens on share:* failures are caught and printed with `debugPrintStack`. Check the console for `Failed to write network logs in file`.
- *Share sheet doesn't open on iPad:* see the iPad note above.
