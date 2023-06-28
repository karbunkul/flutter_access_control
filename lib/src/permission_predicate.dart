import 'package:flutter/widgets.dart';

import 'permission.dart';

abstract class PermissionPredicate {
  final List<Permission> permissions;

  PermissionPredicate(this.permissions);

  Future<bool> resolve(BuildContext context);
}

class Not extends PermissionPredicate {
  final PermissionPredicate group;

  Not(this.group) : super([]);

  @override
  Future<bool> resolve(BuildContext context) async {
    return !(await group.resolve(context));
  }
}

class Single extends PermissionPredicate {
  final Permission permission;

  Single(this.permission) : super([]);

  @override
  Future<bool> resolve(BuildContext context) async {
    return permission.request(context);
  }
}

class Every extends PermissionPredicate {
  Every(super.permissions);

  @override
  Future<bool> resolve(BuildContext context) async {
    if (permissions.isEmpty) {
      return true;
    }

    final res = await Future.wait(permissions.map((permission) async {
      return permission.request(context);
    }));

    return res.firstWhere((element) => element == false, orElse: () => true);
  }
}

class Any extends PermissionPredicate {
  Any(super.permissions);

  @override
  Future<bool> resolve(BuildContext context) async {
    if (permissions.isEmpty) {
      return true;
    }

    final res = await Future.wait(permissions.map((permission) async {
      return permission.request(context);
    }));

    final sum = res.fold<int>(0, (ac, element) => element ? ac + 1 : ac);

    return sum > 0;
  }
}
