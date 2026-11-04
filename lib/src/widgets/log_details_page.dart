import 'package:appdebug/src/model/debug_log.dart';
import 'package:appdebug/src/share/logs_share.dart';
import 'package:material_ui/material_ui.dart';

class LogDetailsPage extends StatelessWidget {
  final DebugLog logEntry;

  const LogDetailsPage({super.key, required this.logEntry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logEntry.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              ShareProvider.shareNetworkLogs([logEntry]);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${logEntry.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text('Message: ${logEntry.message}'),
                const SizedBox(height: 8.0),
                if (logEntry.member != null) Text('Member: \n${logEntry.member}'),
                if (logEntry.location != null) Text('Location: \n${logEntry.location}'),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
