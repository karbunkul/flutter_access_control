access_control

Check access control via permissions

![Access control demo image](https://github.com/karbunkul/flutter_access_control/blob/master/resources/demo.gif "Access control")

## Getting started

Add package to your project ```flutter pub add access_control```.

## Usage

Create permission (implements PermissionInterface)

```dart
class DeveloperPermission extends PermissionInterface {
  final bool developer;

  DeveloperPermission(this.developer);

  @override
  FutureOr<bool> request(BuildContext context) {
    // You can be use context for get data from InheritedWidget or state

    return developer;
  }
}
```

Wrap whole page or other widgets

```dart
class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
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
```
