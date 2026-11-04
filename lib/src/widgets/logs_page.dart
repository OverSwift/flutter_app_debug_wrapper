import 'package:appdebug/src/model/app_logs_loggy_printer.dart';
import 'package:appdebug/src/model/debug_log.dart';
import 'package:appdebug/src/share/logs_share.dart';
import 'package:appdebug/src/widgets/log_details_page.dart';
import 'package:loggy/loggy.dart';
import 'package:material_ui/material_ui.dart';

class LogsPage extends StatefulWidget {
  final ValueNotifier<bool> showDebugButtonNotifier;
  final AppLogsLoggyPrinter logsPrinter;

  const LogsPage({super.key, required this.showDebugButtonNotifier, required this.logsPrinter});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  AppLogsLoggyPrinter get _logs => widget.logsPrinter;

  final List<int> _selectedLogs = [];
  bool _selectionEnabled = false;

  static const _filterLevels = [LogLevel.debug, LogLevel.info, LogLevel.warning, LogLevel.error];
  final Set<LogLevel> _hiddenLevels = {};

  List<DebugLog> get _logsList {
    return _logs.logs.reversed.where((e) => !_hiddenLevels.contains(e.severity)).toList();
  }

  void _toggleLevel(LogLevel level) {
    setState(() {
      if (!_hiddenLevels.remove(level)) _hiddenLevels.add(level);
      _selectedLogs.clear();
      _selectionEnabled = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      widget.showDebugButtonNotifier.value = false;
    });
  }

  @override
  void deactivate() {
    final showDebugButton = widget.showDebugButtonNotifier;
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      showDebugButton.value = true;
    });
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              if (_selectedLogs.isNotEmpty) {
                ShareProvider.shareNetworkLogs(
                  _selectedLogs.map((index) => _logsList[index]).toList(),
                );
              } else {
                ShareProvider.shareNetworkLogs(_logsList);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return StatefulBuilder(
                    builder: (_, setSheetState) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ListTile(title: Text('Filter by log level')),
                          for (final level in _filterLevels)
                            CheckboxListTile(
                              title: Text(level.name),
                              value: !_hiddenLevels.contains(level),
                              onChanged: (_) {
                                _toggleLevel(level);
                                setSheetState(() {});
                              },
                            ),
                          ListTile(title: const Text('Clear logs'), onTap: () {}),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_selectionEnabled)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _selectionEnabled = !_selectionEnabled;
                  if (!_selectionEnabled) {
                    _selectedLogs.clear();
                  }
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _logs,
          builder: (context, child) {
            return ListView.separated(
              itemCount: _logsList.length,
              padding: const EdgeInsets.all(8.0),
              separatorBuilder: (context, index) => const SizedBox(height: 6.0),
              itemBuilder: (context, index) {
                final entry = _logsList[index];

                return ListTile(
                  tileColor: _tileColor(index),
                  selectedTileColor: _tileColor(index),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  trailing: _selectionEnabled
                      ? _selectedLogs.contains(index)
                            ? const Icon(Icons.check_circle)
                            : const Icon(Icons.circle_outlined)
                      : null,
                  selected: _selectedLogs.contains(index),
                  title: Text(entry.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(entry.message, maxLines: 10, overflow: TextOverflow.ellipsis)],
                  ),
                  onLongPress: () {
                    if (_selectionEnabled) {
                      return;
                    }
                    setState(() {
                      _selectionEnabled = !_selectionEnabled;
                      if (!_selectionEnabled) {
                        _selectedLogs.clear();
                      } else {
                        _selectedLogs.add(index);
                      }
                    });
                  },
                  onTap: () {
                    if (_selectionEnabled) {
                      setState(() {
                        if (_selectedLogs.contains(index)) {
                          _selectedLogs.remove(index);
                        } else {
                          _selectedLogs.add(index);
                        }
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogDetailsPage(logEntry: _logsList[index]),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _tileColor(int index) {
    final entry = _logsList[index];
    final isSelected = _selectedLogs.contains(index);
    if (entry.severity == LogLevel.error) {
      return Colors.red[isSelected ? 500 : 300]!;
    } else if (entry.severity == LogLevel.warning) {
      return Colors.yellow[isSelected ? 500 : 300]!;
    } else if (entry.severity == LogLevel.info) {
      return Colors.blue[isSelected ? 500 : 300]!;
    } else if (entry.severity == LogLevel.debug) {
      return Colors.green[isSelected ? 500 : 300]!;
    }
    return Colors.grey[isSelected ? 500 : 300]!;
  }
}
