import 'package:flutter/widgets.dart';

import 'access_control_scope.dart';

typedef RequestCallback = Future<bool> Function(BuildContext context);

class AccessControlRequest extends StatefulWidget {
  final Widget child;
  final Widget? denied;
  final RequestCallback request;

  const AccessControlRequest({
    super.key,
    required this.request,
    required this.child,
    this.denied,
  });

  @override
  State<AccessControlRequest> createState() => _AccessControlRequestState();
}

class _AccessControlRequestState extends State<AccessControlRequest> {
  DateTime _lastReload = DateTime.now();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _activate());
    super.initState();
  }

  @override
  void activate() {
    _activate();
    super.activate();
  }

  @override
  void deactivate() {
    _deactivate();
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant AccessControlRequest oldWidget) {
    _deactivate();
    _activate();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: widget.request(context),
      builder: (_, snap) {
        if (snap.hasData) {
          return KeyedSubtree(
            key: ValueKey(_lastReload),
            child: snap.data == true
                ? widget.child
                : widget.denied ?? const SizedBox(),
          );
        } else if (snap.hasError) {
          throw Exception(snap.error.toString());
        }

        return const SizedBox();
      },
    );
  }

  void _listener() {
    if (mounted) {
      setState(() => _lastReload = DateTime.now());
    }
  }

  void _deactivate() {
    final scope = AccessControlScope.maybeOf(context);
    if (scope != null) {
      scope.removeListener(_listener);
    }
  }

  void _activate() {
    final scope = AccessControlScope.maybeOf(context);
    if (scope != null) {
      scope.addListener(_listener);
    }
  }
}
