import 'dart:async';

import 'package:flutter/widgets.dart';

@Deprecated('Use IPermission instead')
abstract class PermissionInterface with IPermission {}

abstract class IPermission {
  FutureOr<bool> request(BuildContext context);
}
