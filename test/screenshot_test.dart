import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_adaptive_scaffold/prism_adaptive_scaffold.dart';

/// Screenshot generator — renders desktop (extended rail) and phone (bottom
/// bar) showcases into `doc/screenshot.png` and `doc/screenshot_mobile.png`.
/// Run with: `SCREENSHOTS=1 flutter test test/screenshot_test.dart`
void main() {
  const desktopKey = ValueKey('shot-desktop');
  const mobileKey = ValueKey('shot-mobile');

  Future<void> loadFonts() async {
    var dir = Directory('test/fonts');
    if (!dir.existsSync()) {
      dir = Directory('../prism_markdown/test/fonts');
    }
    if (!dir.existsSync()) return;
    final families = <String, List<Uint8List>>{};
    for (final file in dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.ttf'))) {
      final name = file.uri.pathSegments.last.replaceAll('.ttf', '');
      final family = name.startsWith('RobotoMono')
          ? 'monospace'
          : name.substring(0, name.indexOf('-'));
      (families[family] ??= []).add(file.readAsBytesSync());
    }
    for (final entry in families.entries) {
      final loader = FontLoader(entry.key);
      for (final bytes in entry.value) {
        loader.addFont(Future.value(bytes.buffer.asByteData()));
      }
      await loader.load();
    }
    final flutterRoot = File(Platform.resolvedExecutable)
        .parent
        .parent
        .parent
        .parent
        .parent
        .path;
    final iconFont = File(
      '$flutterRoot/bin/cache/artifacts/material_fonts/'
      'MaterialIcons-Regular.otf',
    );
    if (iconFont.existsSync()) {
      final loader = FontLoader('MaterialIcons')
        ..addFont(
          Future.value(iconFont.readAsBytesSync().buffer.asByteData()),
        );
      await loader.load();
    }
  }

  Future<void> capture(
    WidgetTester tester,
    Key boundaryKey,
    Size size,
    String path,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 2.0;
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(boundaryKey),
      );
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final file = File(path);
      await file.create(recursive: true);
      await file.writeAsBytes(byteData!.buffer.asUint8List());
    });
  }

  testWidgets(
    'capture adaptive scaffolds',
    (tester) async {
      await loadFonts();

      // Desktop: extended rail.
      tester.view.physicalSize = const Size(1100, 800);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        RepaintBoundary(
          key: desktopKey,
          child: PrismAdaptiveScaffold(
            destinations: const [
              AdaptiveDestination(
                icon: Icons.inbox_outlined,
                selectedIcon: Icons.inbox,
                label: 'Inbox',
              ),
              AdaptiveDestination(
                icon: Icons.send_outlined,
                selectedIcon: Icons.send,
                label: 'Sent',
              ),
            ],
            currentIndex: 0,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('prism_adaptive_scaffold'),
            ),
            bodyBuilder: (index) => Center(
              child: Text(
                'Page $index',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
      await capture(
        tester,
        desktopKey,
        const Size(1100, 800),
        'doc/screenshot.png',
      );

      // Phone: bottom navigation bar.
      tester.view.physicalSize = const Size(400, 800);
      await tester.pumpWidget(
        RepaintBoundary(
          key: mobileKey,
          child: PrismAdaptiveScaffold(
            destinations: const [
              AdaptiveDestination(
                icon: Icons.inbox_outlined,
                selectedIcon: Icons.inbox,
                label: 'Inbox',
              ),
              AdaptiveDestination(
                icon: Icons.send_outlined,
                selectedIcon: Icons.send,
                label: 'Sent',
              ),
            ],
            currentIndex: 1,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('prism_adaptive_scaffold'),
            ),
            bodyBuilder: (index) => Center(
              child: Text(
                'Page $index',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
      await capture(
        tester,
        mobileKey,
        const Size(400, 800),
        'doc/screenshot_mobile.png',
      );
    },
    skip: !Platform.environment.containsKey('SCREENSHOTS'),
  );
}
