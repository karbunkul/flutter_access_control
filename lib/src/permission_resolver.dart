import 'package:access_control/src/control_mode.dart';
import 'package:flutter/cupertino.dart';

import 'permission.dart';
import 'permission_group.dart';

class PermissionResolver {
  static Future<bool> permission(
    BuildContext context, {
    required Permission permission,
  }) async {
    return permission.request(context);
  }

  static Future<bool> every(
    BuildContext context, {
    required List<Permission> permissions,
  }) {
    return Every(permissions).resolve(context);
  }

  static Future<bool> any(
    BuildContext context, {
    required List<Permission> permissions,
  }) {
    return Any(permissions).resolve(context);
  }

  static Future<bool> permissions(
    BuildContext context, {
    required List<PermissionGroup> groups,
    ControlMode mode = ControlMode.every,
  }) async {
    final res = await Future.wait(groups.map((group) async {
      return group.resolve(context);
    }));

    final sum = res.fold<int>(0, (ac, element) => element ? ac + 1 : ac);

    switch (mode) {
      case ControlMode.every:
        return sum == groups.length;
      case ControlMode.any:
        return sum > 0;
    }
  }
}
