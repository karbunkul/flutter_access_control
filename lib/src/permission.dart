import 'dart:async';

import 'package:flutter/widgets.dart';

@Deprecated('Use Permission instead')
abstract class PermissionInterface with Permission {}

abstract class Permission {
  FutureOr<bool> request(BuildContext context);
}

class Reverse implements Permission {
  final Permission permission;

  Reverse(this.permission);
  @override
  FutureOr<bool> request(BuildContext context) async {
    return !(await permission.request(context));
  }
}
