import 'package:appdebug/appdebug.dart';
import 'package:appdebug_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loggy/loggy.dart';

void main() {
  testWidgets('example app renders and generates logs', (tester) async {
    // main() isn't run in widget tests, so initialise logging here.
    Loggy.initLoggy(
      logPrinter: MultyDestinationLoggyPrinter(printers: [logsPrinter]),
    );

    await tester.pumpWidget(const ExampleApp());
    expect(find.text('appdebug example'), findsWidgets);

    final before = logsPrinter.logs.length;
    await tester.tap(find.textContaining('Log all levels'));
    await tester.pump();
    expect(logsPrinter.logs.length, greaterThan(before));
  });
}
