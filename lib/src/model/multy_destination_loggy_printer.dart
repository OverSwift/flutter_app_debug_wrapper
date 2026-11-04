import 'package:loggy/loggy.dart';

class MultyDestinationLoggyPrinter extends LoggyPrinter {
  List<LoggyPrinter> printers;

  MultyDestinationLoggyPrinter({required this.printers});

  @override
  void onLog(LogRecord record) {
    for (final printer in printers) {
      printer.onLog(record);
    }
  }
}
