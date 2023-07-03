import 'dart:async';

import 'package:access_control/access_control.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

typedef ResolverCallback = Future<bool> Function();

class DevelopmentPermission extends Permission {
  final bool value;

  DevelopmentPermission(this.value);

  @override
  FutureOr<bool> request(BuildContext context) => value;
}

class DarkThemePermission extends Permission {
  final bool value;

  DarkThemePermission(this.value);

  @override
  FutureOr<bool> request(BuildContext context) => value;
}

class BuildContextMock extends Mock implements BuildContext {}

void main() {
  setUpAll(() {
    registerFallbackValue(BuildContextMock());
  });

  test('permission Reverse', () {
    _testReversePermission(DevelopmentPermission(true));
    _testReversePermission(DevelopmentPermission(false));
  });

  group('predicates', () {
    test('predicate Not', () {
      _testNotPredicate(Single(DevelopmentPermission(true)));
      _testNotPredicate(Single(DevelopmentPermission(false)));
    });

    test('predicate Every', () {
      /// both predicate is true, expected true
      _testEveryPredicate(
        permissions: [DevelopmentPermission(true), DarkThemePermission(true)],
        expected: true,
      );

      /// both predicate is not equals, expected false
      _testEveryPredicate(
        permissions: [DevelopmentPermission(true), DarkThemePermission(false)],
        expected: false,
      );

      /// both predicate is false, expected false
      _testEveryPredicate(
        permissions: [DevelopmentPermission(false), DarkThemePermission(false)],
        expected: false,
      );
    });

    test('predicate Any', () {
      /// both predicate is true, expected true
      _testAnyPredicate(
        permissions: [DevelopmentPermission(true), DarkThemePermission(true)],
        expected: true,
      );

      /// both predicate is not equals, expected true
      _testAnyPredicate(
        permissions: [DevelopmentPermission(true), DarkThemePermission(false)],
        expected: true,
      );

      /// both predicate is false, expected false
      _testAnyPredicate(
        permissions: [DevelopmentPermission(false), DarkThemePermission(false)],
        expected: false,
      );
    });

    test('predicate Single', () {
      final permission = DevelopmentPermission(true);
      expect(permission, equals(Single(permission).permission));
    });
  });

  group('resolver', () {
    final context = BuildContextMock();

    test('permission', () async {
      _testResolver(
        () => PermissionResolver.permission(
          context,
          permission: DevelopmentPermission(true),
        ),
        expected: true,
      );

      _testResolver(
        () => PermissionResolver.permission(
          context,
          permission: DevelopmentPermission(false),
        ),
        expected: false,
      );
    });

    test('every', () {
      /// empty permissions is true
      _testResolver(
        () => PermissionResolver.every(context, permissions: []),
        expected: true,
      );

      /// both permissions is true, expected true
      _testResolver(
        () => PermissionResolver.every(context, permissions: [
          DevelopmentPermission(true),
          DarkThemePermission(true),
        ]),
        expected: true,
      );

      /// both permissions is false, expected false
      _testResolver(
        () => PermissionResolver.every(context, permissions: [
          DevelopmentPermission(false),
          DarkThemePermission(false),
        ]),
        expected: false,
      );

      /// both predicate is not equals, expected false
      _testResolver(
        () => PermissionResolver.every(context, permissions: [
          DevelopmentPermission(true),
          DarkThemePermission(false),
        ]),
        expected: false,
      );
    });

    test('any', () {
      /// empty permissions is true
      _testResolver(
        () => PermissionResolver.any(context, permissions: []),
        expected: true,
      );

      /// both permissions is true, expected true
      _testResolver(
        () => PermissionResolver.any(context, permissions: [
          DevelopmentPermission(true),
          DarkThemePermission(true),
        ]),
        expected: true,
      );

      /// both permissions is false, expected false
      _testResolver(
        () => PermissionResolver.any(context, permissions: [
          DevelopmentPermission(false),
          DarkThemePermission(false),
        ]),
        expected: false,
      );

      /// both predicate is not equals, expected true
      _testResolver(
        () => PermissionResolver.any(context, permissions: [
          DevelopmentPermission(true),
          DarkThemePermission(false),
        ]),
        expected: true,
      );
    });

    test('permissions', () {
      _testResolver(
        () => PermissionResolver.permissions(
          context,
          predicates: [
            Single(DevelopmentPermission(true)),
            Single(Reverse(DevelopmentPermission(true))),
          ],
          mode: ControlMode.any,
        ),
        expected: true,
      );

      _testResolver(
        () => PermissionResolver.permissions(
          context,
          predicates: [
            Single(DevelopmentPermission(true)),
            Single(Reverse(DevelopmentPermission(false))),
          ],
          mode: ControlMode.every,
        ),
        expected: true,
      );
    });
  });
}

Future<void> _testResolver(ResolverCallback callback,
    {required bool expected}) async {
  final actual = await callback();
  expect(actual, equals(expected));
}

/// test Reverse permission, actual must be not expected
Future<void> _testReversePermission(Permission permission) async {
  final context = BuildContextMock();
  final expected = await permission.request(context);
  final actual = await Reverse(permission).request(context);
  expect(actual, equals(!expected));
}

/// test Not predicate, actual must be not expected
Future<void> _testNotPredicate(PermissionPredicate value) async {
  final context = BuildContextMock();
  final expected = await value.resolve(context);
  final actual = await Not(value).resolve(context);
  expect(actual, equals(!expected));
}

/// test Any predicate, actual must be equal expected
Future<void> _testAnyPredicate({
  required List<Permission> permissions,
  required bool expected,
}) async {
  final context = BuildContextMock();
  final actual = await Any(permissions).resolve(context);
  expect(actual, equals(expected));
}

/// test Any predicate, actual must be equal expected
Future<void> _testEveryPredicate({
  required List<Permission> permissions,
  required bool expected,
}) async {
  final context = BuildContextMock();
  final actual = await Every(permissions).resolve(context);
  expect(actual, equals(expected));
}
