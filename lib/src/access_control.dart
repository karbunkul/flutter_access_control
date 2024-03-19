import 'package:access_control/src/access_control_request.dart';
import 'package:access_control/src/control_mode.dart';
import 'package:access_control/src/permission.dart';
import 'package:access_control/src/permission_predicate.dart';
import 'package:access_control/src/permission_resolver.dart';
import 'package:flutter/widgets.dart';

abstract class AccessControl extends StatelessWidget {
  const AccessControl({
    super.key,
    required Widget child,
    required List<Permission> permissions,
    Widget? denied,
  });

  @Deprecated('Use AccessControl.permission instead')
  factory AccessControl.single({
    Key? key,
    required Permission permission,
    required Widget child,
    Widget? denied,
  }) {
    return AccessControl.permission(
      key: key,
      permission: permission,
      denied: denied,
      child: child,
    );
  }

  @Deprecated('Use PermissionResolver.permission instead')
  static Future<bool> check(
    BuildContext context,
    Permission permission,
  ) {
    return PermissionResolver.permission(
      context,
      permission: permission,
    );
  }

  @Deprecated('Use PermissionResolver.permissions instead')
  static Future<bool> checkMany(
    BuildContext context,
    List<Permission> permissions,
  ) {
    return PermissionResolver.every(
      context,
      permissions: permissions,
    );
  }

  /// Validate single permission
  factory AccessControl.permission({
    Key? key,
    required Permission permission,
    required Widget child,
    Widget? denied,
  }) {
    return _AccessControl(
      child: AccessControlRequest(
        key: key,
        request: (context) {
          return PermissionResolver.permission(
            context,
            permission: permission,
          );
        },
        denied: denied,
        child: child,
      ),
    );
  }

  /// Validate all permissions
  factory AccessControl.every({
    Key? key,
    required List<Permission> permissions,
    required Widget child,
    Widget? denied,
  }) {
    return _AccessControl(
      child: AccessControlRequest(
        key: key,
        request: (context) {
          return PermissionResolver.every(
            context,
            permissions: permissions,
          );
        },
        denied: denied,
        child: child,
      ),
    );
  }

  /// Validate one of permissions
  factory AccessControl.any({
    Key? key,
    required List<Permission> permissions,
    required Widget child,
    Widget? denied,
  }) {
    return _AccessControl(
      child: AccessControlRequest(
        key: key,
        request: (context) {
          return PermissionResolver.any(
            context,
            permissions: permissions,
          );
        },
        denied: denied,
        child: child,
      ),
    );
  }

  /// Validate permission groups
  factory AccessControl.permissions({
    Key? key,
    required List<PermissionPredicate> predicates,
    required ControlMode mode,
    required Widget child,
    Widget? denied,
  }) {
    return _AccessControl(
      child: AccessControlRequest(
        key: key,
        request: (context) {
          return PermissionResolver.permissions(
            context,
            predicates: predicates,
            mode: mode,
          );
        },
        denied: denied,
        child: child,
      ),
    );
  }
}

class _AccessControl extends StatelessWidget implements AccessControl {
  final Widget child;

  const _AccessControl({required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
