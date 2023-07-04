import 'dart:async';
import 'dart:math';

import 'package:access_control/access_control.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DemoPage(),
      builder: (_, child) {
        return AccessControlManager(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

enum PermissionAspect { theme, auth, develop }

class PermissionModel extends InheritedModel<PermissionAspect> {
  final bool? developer;
  final bool? darkTheme;
  final bool? authorized;

  const PermissionModel({
    super.key,
    required super.child,
    this.developer,
    this.darkTheme,
    this.authorized,
  });

  static bool isDeveloperOf(BuildContext context) =>
      InheritedModel.inheritFrom<PermissionModel>(
        context,
        aspect: PermissionAspect.develop,
      )?.developer ??
      false;

  static bool isDarkThemeOf(BuildContext context) =>
      InheritedModel.inheritFrom<PermissionModel>(
        context,
        aspect: PermissionAspect.theme,
      )?.darkTheme ??
      false;

  static bool isAuthorizedOf(BuildContext context) =>
      InheritedModel.inheritFrom<PermissionModel>(
        context,
        aspect: PermissionAspect.auth,
      )?.authorized ??
      false;

  @override
  bool updateShouldNotifyDependent(InheritedModel<PermissionAspect> oldWidget,
      Set<PermissionAspect> dependencies) {
    final old = oldWidget as PermissionModel;

    if (developer != old.developer &&
        dependencies.contains(PermissionAspect.develop)) {
      return true;
    }

    if (darkTheme != old.darkTheme &&
        dependencies.contains(PermissionAspect.theme)) {
      return true;
    }

    if (authorized != old.authorized &&
        dependencies.contains(PermissionAspect.auth)) {
      return true;
    }

    return false;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    final old = oldWidget as PermissionModel;
    return old.developer != developer ||
        old.darkTheme != darkTheme ||
        old.authorized != authorized;
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class DeveloperPermission implements Permission {
  @override
  FutureOr<bool> request(BuildContext context) =>
      PermissionModel.isDeveloperOf(context);
}

class AuthPermission implements Permission {
  @override
  FutureOr<bool> request(BuildContext context) =>
      PermissionModel.isAuthorizedOf(context);
}

class DarkThemePermission implements Permission {
  @override
  FutureOr<bool> request(BuildContext context) =>
      PermissionModel.isDarkThemeOf(context);
}

class RandomPermission implements Permission {
  @override
  FutureOr<bool> request(BuildContext context) {
    return Random().nextBool();
  }
}

class ThemeButton extends StatelessWidget {
  final VoidCallback onTap;
  const ThemeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = PermissionModel.isDarkThemeOf(context);

    return IconButton(
        onPressed: onTap,
        icon: Icon(!isDarkTheme ? Icons.dark_mode : Icons.light_mode));
  }
}

class _DemoPageState extends State<DemoPage> {
  bool _developer = false;
  bool _darkTheme = false;
  bool _authorized = false;

  @override
  Widget build(BuildContext context) {
    return PermissionModel(
      developer: _developer,
      darkTheme: _darkTheme,
      authorized: _authorized,
      child: Theme(
        data: _darkTheme
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Access control'),
            actions: [
              ThemeButton(
                onTap: () => setState(() => _darkTheme = !_darkTheme),
              ),
            ],
          ),
          body: Column(
            children: [
              Text(_developer ? 'Developer' : 'User'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AccessControl.permission(
                  permission: AuthPermission(),
                  child: Column(
                    children: [
                      const FlutterLogo(size: 96),
                      ListTile(
                        title: Text(
                          DateTime.now().microsecondsSinceEpoch.toString(),
                        ),
                        onTap: AccessControlScope.of(context).rebuild,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        child: const Center(child: Text('Logout')),
                        onPressed: () => setState(() => _authorized = false),
                      ),
                    ],
                  ),
                  denied: ElevatedButton(
                    child: const Center(child: Text('Login')),
                    onPressed: () => setState(() => _authorized = true),
                  ),
                ),
              ),
              AccessControl.permission(
                permission: RandomPermission(),
                child: const Text('true'),
                denied: const Text('false'),
              ),
              AccessControl.permissions(
                predicates: [
                  Not(
                    Any([
                      DeveloperPermission(),
                      DarkThemePermission(),
                    ]),
                  ),
                  Single(
                    Reverse(AuthPermission()),
                  ),
                ],
                mode: ControlMode.every,
                child: const Text('Cool'),
              ),
              AccessControl.every(
                child: Builder(builder: (context) {
                  return const Text('Developers love dark themes');
                }),
                permissions: [
                  AuthPermission(),
                  DeveloperPermission(),
                  DarkThemePermission(),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              _developer ? Icons.person_outline : Icons.bug_report_outlined,
            ),
            onPressed: () => setState(() => _developer = !_developer),
          ),
        ),
      ),
    );
  }
}
