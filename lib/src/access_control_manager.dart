import 'package:flutter/widgets.dart';

import 'access_control_scope.dart';

class AccessControlManager extends StatefulWidget {
  final Widget child;
  const AccessControlManager({super.key, required this.child});

  @override
  State<AccessControlManager> createState() => _AccessControlManagerState();
}

class _AccessControlManagerState extends State<AccessControlManager> {
  final _subscriber = _Subscriber();

  @override
  Widget build(BuildContext context) {
    return AccessControlScope(
      addListener: _subscriber.addListener,
      removeListener: _subscriber.removeListener,
      rebuild: _subscriber.reload,
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
