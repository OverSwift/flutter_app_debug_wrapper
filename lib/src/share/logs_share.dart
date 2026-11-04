import 'dart:io';

import 'package:appdebug/src/model/debug_log.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareProvider {
  static void shareNetworkLogs(List<DebugLog> networkLogs) async {
    try {
      final file = await _writeNetworkLogsInFile(networkLogs);

      final params = ShareParams(
        text: 'Debug Logs',
        title: 'Debug Logs',
        subject: 'Debug Logs',
        files: [XFile(file.path, mimeType: 'text/*')],
      );
      await SharePlus.instance.share(params);
    } on Exception catch (ex, st) {
      debugPrintStack(label: 'Failed to write network logs in file: $ex', stackTrace: st);
    }
  }

  static Future<File> _writeNetworkLogsInFile(List<DebugLog> logs) async {
    final file = await _createFile('network_logs_');
    final sortedLogs = <DebugLog>[];
    sortedLogs.addAll(logs);

    for (final log in sortedLogs) {
      file.writeAsStringSync(
        '${log.toString()}\n------------------------------------------------\n',
        mode: FileMode.append,
      );
    }

    return file;
  }

  static Future<File> _createFile(String prefix) async {
    final directory = await getTemporaryDirectory();
    final name = '$prefix${DateTime.now().millisecondsSinceEpoch}.txt';
    final path = '${directory.path}/$name';
    final file = File(path);

    return file;
  }
}
