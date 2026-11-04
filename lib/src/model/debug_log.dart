import 'package:loggy/loggy.dart';

class DebugLog {
  final DateTime timestamp = DateTime.now();

  final String title;
  final String message;

  final String? member;
  final String? location;

  final LogLevel severity;

  DebugLog({
    required this.title,
    required this.message,
    this.member,
    this.location,
    required this.severity,
  });

  @override
  String toString() {
    return '''
    DebugLog(
      timestamp: $timestamp,
      title: $title,
      message: $message,
      member: $member,
      location: $location,
      severity: $severity
    )''';
  }
}
