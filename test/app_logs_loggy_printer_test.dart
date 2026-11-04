import 'package:appdebug/appdebug.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loggy/loggy.dart';

void main() {
  test('printer collects logs and notifies listeners', () {
    final printer = AppLogsLoggyPrinter();
    var notified = 0;
    printer.addListener(() => notified++);

    printer.onLog(LogRecord(LogLevel.info, 'hello', 'test'));

    expect(printer.logs, hasLength(1));
    expect(printer.logs.first.message, 'hello');
    expect(notified, 1);
  });
}
