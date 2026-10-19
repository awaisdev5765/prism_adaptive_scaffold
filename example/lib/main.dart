import 'package:flutter/material.dart';
import 'package:prism_adaptive_scaffold/prism_adaptive_scaffold.dart';

void main() {
  runApp(const DemoApp());
}

/// Demonstrates how [PrismAdaptiveScaffold] adapts to window size.
/// Resize the window to see bottom bar → rail → extended rail transitions.
class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'prism_adaptive_scaffold demo',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _index = 0;

  static const _destinations = [
    AdaptiveDestination(
      icon: Icons.inbox_outlined,
      selectedIcon: Icons.inbox,
      label: 'Inbox',
    ),
    AdaptiveDestination(
      icon: Icons.star_outlined,
      selectedIcon: Icons.star,
      label: 'Starred',
    ),
    AdaptiveDestination(
      icon: Icons.send_outlined,
      selectedIcon: Icons.send,
      label: 'Sent',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PrismAdaptiveScaffold(
      destinations: _destinations,
      currentIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      appBar: AppBar(title: const Text('prism_adaptive_scaffold demo')),
      bodyBuilder: (index) => Center(
        child: Text(
          'Page $index',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
