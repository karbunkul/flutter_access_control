import 'package:flutter/widgets.dart';

class AccessControlReloadScope extends InheritedWidget {
  final ValueChanged<VoidCallback> addListener;
  final ValueChanged<VoidCallback> removeListener;

  const AccessControlReloadScope({
    super.key,
    required this.addListener,
    required this.removeListener,
    required Widget child,
  }) : super(child: child);

  static AccessControlReloadScope of(BuildContext context) {
    final AccessControlReloadScope? result =
        context.dependOnInheritedWidgetOfExactType<AccessControlReloadScope>();
    assert(result != null, 'No _Scope found in context');
    return result!;
  }

  static AccessControlReloadScope? maybeOf(BuildContext context) {
    final AccessControlReloadScope? result =
        context.dependOnInheritedWidgetOfExactType<AccessControlReloadScope>();

    return result;
  }

  @override
  bool updateShouldNotify(AccessControlReloadScope oldWidget) {
    return false;
  }
}
