import 'dart:async';

import 'package:access_control/access_control.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: DemoPage());
}

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class DeveloperPermission extends PermissionInterface {
  final bool developer;

  DeveloperPermission(this.developer);

  @override
  FutureOr<bool> request(BuildContext context) {
    return developer;
  }
}

class _DemoPageState extends State<DemoPage> {
  var developer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access control')),
      body: Center(
        child: AccessControl.single(
          child: const Text('Developer workspace'),
          denied: const Text('Access denied'),
          permission: DeveloperPermission(developer),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          developer ? Icons.person_outline : Icons.bug_report_outlined,
        ),
        onPressed: () => setState(() => developer = !developer),
      ),
    );
  }
}
