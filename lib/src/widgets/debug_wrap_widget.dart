import 'package:appdebug/src/model/app_logs_loggy_printer.dart';
import 'package:appdebug/src/widgets/draggable_button.dart';
import 'package:appdebug/src/widgets/logs_page.dart';
import 'package:material_ui/material_ui.dart';

class DebugView extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final bool showDebugViewButton;
  final Widget? app;

  /// Printer that collects the logs shown in the log viewer.
  final AppLogsLoggyPrinter logsPrinter;

  const DebugView({
    super.key,
    required this.navigatorKey,
    required this.showDebugViewButton,
    required this.app,
    required this.logsPrinter,
  });

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  final _showDebugButtonNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final viewPadding = MediaQuery.paddingOf(context);
    final safeAreaBottomPadding = viewPadding.bottom;
    const buttonPadding = 80.0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: ValueListenableBuilder<bool>(
          valueListenable: _showDebugButtonNotifier,
          builder: (_, showDebugButton, _) {
            return LayoutBuilder(
              builder: (_, constraints) {
                final horizontalOffset = constraints.maxWidth - buttonPadding;
                final verticalOffset =
                    constraints.maxHeight - safeAreaBottomPadding - buttonPadding;

                return Stack(
                  children: [
                    ?app,
                    if (widget.showDebugViewButton)
                      DraggableFloatingActionButton(
                        scaleFactor: showDebugButton ? 1 : 0,
                        topPadding: viewPadding.top,
                        bottomPadding: safeAreaBottomPadding,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight - safeAreaBottomPadding,
                        initialOffset: Offset(horizontalOffset, verticalOffset),
                        onPressed: _onDebugButtonPressed(showDebugButton),
                        onError: (e) =>
                            debugPrint('Failed to init DraggableFloatingActionButton: $e'),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  VoidCallback? _onDebugButtonPressed(bool showDebugButton) {
    if (!showDebugButton) return null;
    // return null;
    return () => widget.navigatorKey?.currentState?.push(
      MaterialPageRoute(
        builder: (context) => LogsPage(
          showDebugButtonNotifier: _showDebugButtonNotifier,
          logsPrinter: widget.logsPrinter,
        ),
      ),
    );
  }
}
