import 'package:appdebug/appdebug.dart';
import 'package:loggy/loggy.dart';
import 'package:material_ui/material_ui.dart';

/// Collects every log record so the debug overlay can display it.
final logsPrinter = AppLogsLoggyPrinter();

/// Shared with [DebugView] so it can push the logs page onto the app's navigator.
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 1. Send logs both to the console and to the in-app log viewer.
  Loggy.initLoggy(
    logPrinter: MultyDestinationLoggyPrinter(printers: [const PrettyPrinter(), logsPrinter]),
    logOptions: const LogOptions(LogLevel.all, includeCallerInfo: true),
  );

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'appdebug example',
      navigatorKey: navigatorKey,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );

    // 2. Wrap the app. Usually only in debug builds: `showDebugViewButton: kDebugMode`.
    return DebugView(
      navigatorKey: navigatorKey,
      showDebugViewButton: true,
      logsPrinter: logsPrinter,
      app: app,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _logAll() {
    logDebug('Debug message #$_counter');
    logInfo('Info message #$_counter');
    logWarning('Warning message #$_counter');
    logError('Error message #$_counter');
  }

  void _logException() {
    try {
      throw StateError('Something went wrong (#$_counter)');
    } catch (e, st) {
      logError('Caught exception: $e', e, st);
    }
  }

  void _generate() {
    setState(() => _counter++);
    _logAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('appdebug example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tap the draggable debug button to open the log viewer.\n'
                'Use the buttons below to generate logs.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _generate, child: Text('Log all levels ($_counter)')),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _logException, child: const Text('Log an exception')),
            ],
          ),
        ),
      ),
    );
  }
}
