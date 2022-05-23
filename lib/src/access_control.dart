import 'package:access_control/src/permission_interface.dart';
import 'package:flutter/widgets.dart';

class AccessControl extends StatelessWidget {
  final Widget child;
  final Widget? denied;
  final List<PermissionInterface> permissions;

  const AccessControl({
    Key? key,
    required this.child,
    required this.permissions,
    this.denied,
  })  : assert(permissions.length > 0),
        super(key: key);

  static Future<bool> check(
    BuildContext context,
    PermissionInterface permission,
  ) async {
    return await permission.request(context);
  }

  static Future<bool> checkMany(
    BuildContext context,
    List<PermissionInterface> permissions,
  ) async {
    if (permissions.length > 1) {
      var res = await Future.wait(permissions.map((e) {
        return AccessControl.check(context, e);
      }));

      return res.firstWhere(
        (element) => element == false,
        orElse: () => true,
      );
    }

    return AccessControl.check(context, permissions[0]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AccessControl.checkMany(context, permissions),
      builder: (_, snap) {
        if (snap.hasData) {
          return snap.data! ? child : denied ?? const SizedBox();
        } else if (snap.hasError) {
          throw Exception(snap.error.toString());
        }

        return Container();
      },
    );
  }

  factory AccessControl.single({
    required Widget child,
    Widget? denied,
    required PermissionInterface permission,
  }) {
    return AccessControl(
      child: child,
      permissions: [permission],
      denied: denied,
    );
  }
}
