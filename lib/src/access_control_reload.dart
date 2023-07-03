import 'package:flutter/widgets.dart';

import 'access_control_reload_scope.dart';

class AccessControlReload extends StatefulWidget {
  final Widget child;
  const AccessControlReload({super.key, required this.child});

  @override
  State<AccessControlReload> createState() => _AccessControlReloadState();

  static void reload(BuildContext context) {
    final state = context.findAncestorStateOfType<_AccessControlReloadState>()!;
    state._subscriber.reload();
  }
}

class _AccessControlReloadState extends State<AccessControlReload> {
  final _subscriber = _Subscriber();

  @override
  Widget build(BuildContext context) {
    return AccessControlReloadScope(
      addListener: _subscriber.addListener,
      removeListener: _subscriber.removeListener,
      child: widget.child,
    );
  }
}

class _Subscriber extends ChangeNotifier {
  void reload() {
    if (hasListeners) {
      notifyListeners();
    }
  }
}
