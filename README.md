# prism_adaptive_scaffold

A **responsive adaptive scaffold for Flutter** — the maintained replacement
for the discontinued `flutter_adaptive_scaffold`. One widget, three layouts:
bottom navigation bar on phones, a navigation rail on tablets, and an
extended rail with labels on desktop. Pure Flutter — no platform channels.

## Features

- ✅ Material 3 adaptive navigation: bottom bar → rail → extended rail
- ✅ Canonical M3 breakpoints (compact / medium / expanded / extra-large)
- ✅ Animated body transitions between destinations
- ✅ Drop-in API: pass destinations + a body builder, done
- ✅ Works on all six Flutter platforms: Android, iOS, macOS, Windows, Linux, Web

## Installation

```yaml
dependencies:
  prism_adaptive_scaffold: ^0.1.0
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:prism_adaptive_scaffold/prism_adaptive_scaffold.dart';

PrismAdaptiveScaffold(
  destinations: const [
    AdaptiveDestination(icon: Icons.inbox_outlined, label: 'Inbox'),
    AdaptiveDestination(icon: Icons.send_outlined, label: 'Sent'),
  ],
  currentIndex: _index,
  onDestinationSelected: (i) => setState(() => _index = i),
  bodyBuilder: (index) => Center(child: Text('Page $index')),
)
```

Resize the window (or run on desktop) and watch the navigation adapt.

## Custom breakpoints

Pass your own thresholds to `PrismBreakpoint.resolve`, or compare directly:

```dart
final bp = PrismBreakpoint.resolve(MediaQuery.sizeOf(context).width);
if (bp == PrismBreakpoint.expanded) {
  // Show a two-pane layout.
}
```

## License

MIT — see [LICENSE](LICENSE).
