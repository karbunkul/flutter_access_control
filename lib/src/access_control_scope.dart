import 'package:flutter/widgets.dart';

class AccessControlScope extends InheritedWidget {
  final ValueChanged<VoidCallback> addListener;
  final ValueChanged<VoidCallback> removeListener;
  final VoidCallback rebuild;

  const AccessControlScope({
    super.key,
    required this.addListener,
    required this.removeListener,
    required this.rebuild,
    required super.child,
  });

  static AccessControlScope of(BuildContext context) {
    final AccessControlScope? result =
        context.dependOnInheritedWidgetOfExactType<AccessControlScope>();
    assert(result != null, 'No _Scope found in context');
    return result!;
  }

  static AccessControlScope? maybeOf(BuildContext context) {
    final AccessControlScope? result =
        context.dependOnInheritedWidgetOfExactType<AccessControlScope>();

    return result;
  }

  @override
  bool updateShouldNotify(AccessControlScope oldWidget) {
    return false;
  }
}
