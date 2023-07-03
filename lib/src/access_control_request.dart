import 'package:flutter/widgets.dart';

import 'access_control_reload_scope.dart';

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
  var _lastRebuild = DateTime.now();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_postFrame);
    super.initState();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      // key: ValueKey(_lastRebuild),
      child: FutureBuilder<bool>(
        future: widget.request(context),
        builder: (_, snap) {
          if (snap.hasData) {
            return snap.data!
                ? widget.child
                : widget.denied ?? const SizedBox();
          } else if (snap.hasError) {
            throw Exception(snap.error.toString());
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _listener() {
    if (mounted) {
      setState(() {
        _lastRebuild = DateTime.now();
      });
    }
  }

  void _postFrame(Duration timeStamp) {
    final scope = AccessControlReloadScope.maybeOf(context);
    if (scope != null) {
      scope.addListener(_listener);
    }
  }

  void _dispose() {
    final scope = AccessControlReloadScope.maybeOf(context);
    if (scope != null) {
      scope.removeListener(_listener);
    }
  }
}
