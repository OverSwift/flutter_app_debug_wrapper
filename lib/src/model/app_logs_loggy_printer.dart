import 'package:appdebug/src/model/debug_log.dart';
import 'package:flutter/foundation.dart';
import 'package:loggy/loggy.dart';

class AppLogsLoggyPrinter extends LoggyPrinter with ChangeNotifier {
  final List<DebugLog> logs = [];

  @override
  void onLog(LogRecord record) {
    // Create debug log message

    final member = record.callerFrame?.member;
    final location = record.callerFrame?.location;
    final debugLog = DebugLog(
      title: record.level.name,
      message: record.message,
      member: member,
      location: location,
      severity: record.level,
    );
    logs.add(debugLog);
    notifyListeners();
  }
}
