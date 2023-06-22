import 'dart:async';

import 'package:access_control/access_control.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: DemoPage());
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

class DeveloperPermission extends IPermission {
  @override
  FutureOr<bool> request(BuildContext context) =>
      PermissionModel.isDeveloperOf(context);
}

class AuthPermission extends IPermission {
  @override
  FutureOr<bool> request(BuildContext context) =>
      PermissionModel.isAuthorizedOf(context);
}

class DarkThemePermission extends IPermission {
  @override
  FutureOr<bool> request(BuildContext context) =>
      PermissionModel.isDarkThemeOf(context);
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AccessControl.permission(
                  permission: AuthPermission(),
                  child: Column(
                    children: [
                      const FlutterLogo(size: 96),
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
              AccessControl.permissions(
                groups: [
                  Not(Any([DeveloperPermission(), DarkThemePermission()])),
                  Every([AuthPermission()])
                ],
                mode: ControlMode.any,
                child: const Text('Cool'),
              ),
              AccessControl.every(
                child: const Text('Developers love dark themes'),
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
