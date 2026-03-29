import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:longpress_preview/longpress_preview.dart';

void main() {
  group('LongPressPreview', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LongPressPreview(
              preview: Text('Preview content'),
              child: Text('Long press me'),
            ),
          ),
        ),
      );
      expect(find.text('Long press me'), findsOneWidget);
      expect(find.text('Preview content'), findsNothing);
    });

    testWidgets('shows preview on long press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LongPressPreview(
              config: const PreviewConfig(
                enableHaptics: false,
                longPressDuration: Duration(milliseconds: 500),
              ),
              preview: const Text('Preview content'),
              child: const Text('Long press me'),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(tester.getCenter(find.text('Long press me')));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Preview content'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('onTap is called on normal tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LongPressPreview(
              preview: const Text('Preview'),
              onTap: () => tapped = true,
              child: const Text('Tap me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('PreviewConfig defaults are correct', (tester) async {
      const config = PreviewConfig();
      expect(config.borderRadius, 16.0);
      expect(config.enableHaptics, isTrue);
      expect(config.animation, PreviewAnimation.scaleFromChild);
    });
  });

  group('OgpData', () {
    test('holds all fields', () {
      const data = OgpData(
        url: 'https://example.com',
        title: 'Test Title',
        description: 'Test description',
        imageUrl: 'https://example.com/image.jpg',
        faviconUrl: 'https://example.com/favicon.ico',
        siteName: 'Example',
      );
      expect(data.url, 'https://example.com');
      expect(data.title, 'Test Title');
      expect(data.siteName, 'Example');
    });
  });
}
