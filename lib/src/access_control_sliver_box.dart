import 'package:access_control/src/access_control_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'control_mode.dart';
import 'permission.dart';
import 'permission_predicate.dart';
import 'permission_resolver.dart';

abstract class AccessControlSliverBox extends SingleChildRenderObjectWidget {
  /// Validate single permission
  factory AccessControlSliverBox.permission({
    Key? key,
    required Permission permission,
    required Widget child,
    Widget? denied,
  }) {
    return _RenderSliver(
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
  factory AccessControlSliverBox.every({
    Key? key,
    required List<Permission> permissions,
    required Widget child,
    Widget? denied,
  }) {
    return _RenderSliver(
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
  factory AccessControlSliverBox.any({
    Key? key,
    required List<Permission> permissions,
    required Widget child,
    Widget? denied,
  }) {
    return _RenderSliver(
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
  factory AccessControlSliverBox.permissions({
    Key? key,
    required List<PermissionPredicate> predicates,
    required ControlMode mode,
    required Widget child,
    Widget? denied,
  }) {
    return _RenderSliver(
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

class _RenderSliver extends SingleChildRenderObjectWidget
    implements AccessControlSliverBox {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverToBoxAdapter();
  }

  const _RenderSliver({super.child});
}
