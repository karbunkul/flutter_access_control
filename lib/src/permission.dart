import 'dart:async';

import 'package:flutter/widgets.dart';

abstract interface class Permission {
  FutureOr<bool> request(BuildContext context);
}

class Reverse implements Permission {
  final Permission permission;

  const Reverse(this.permission);

  @override
  FutureOr<bool> request(BuildContext context) async {
    return !(await permission.request(context));
  }
}
