# appdebug example

Minimal app showing how to use the `appdebug` package.

## Run

```sh
cd example
flutter run
```

## What it shows

See `lib/main.dart`:

1. Create an `AppLogsLoggyPrinter` and register it with Loggy through `MultyDestinationLoggyPrinter` (console plus in-app viewer).
2. Give the `MaterialApp` a `navigatorKey` and pass the same key to `DebugView`.
3. Wrap the app in `DebugView`. In a real app, gate it with `kDebugMode`.

Tap the draggable button to open the log viewer. Use the buttons on the home screen to generate logs at each level, or an exception with a stack trace. From the viewer you can open log details and share logs. See the main README for `share_plus` platform notes.
