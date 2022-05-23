import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class PermissionInterface {
  FutureOr<bool> request(BuildContext context);
}
