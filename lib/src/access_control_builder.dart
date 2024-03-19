import 'package:access_control/src/permission.dart';
import 'package:access_control/src/permission_resolver.dart';
import 'package:flutter/widgets.dart';

typedef AccessBuilder = Widget Function(BuildContext context, bool value);

class AccessControlBuilder extends StatefulWidget {
  final AccessBuilder builder;
  final List<Permission> permissions;

  const AccessControlBuilder({
    required this.builder,
    required this.permissions,
    super.key,
  });

  @override
  State<AccessControlBuilder> createState() => _AccessControlBuilderState();
}

class _AccessControlBuilderState extends State<AccessControlBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PermissionResolver.every(
        context,
        permissions: widget.permissions,
      ),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.done && snap.hasData) {
          return widget.builder(context, snap.data!);
        }

        return const SizedBox();
      },
    );
  }

  @override
  void didUpdateWidget(AccessControlBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}
