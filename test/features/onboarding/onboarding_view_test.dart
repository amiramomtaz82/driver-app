import 'package:driver_app/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import 'dart:typed_data';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.startsWith('assets/images/')) {
      final Uint8List transparentImage = Uint8List.fromList(<int>[
        0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1f, 0x15, 0xc4, 0x89, 0x00, 0x00, 0x00,
        0x0a, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9c, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0d, 0x0a, 0x2d, 0xb4, 0x00, 0x00, 0x00, 0x00, 0x49,
        0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82,
      ]);
      return ByteData.view(transparentImage.buffer);
    }
    return rootBundle.load(key);
  }
}

Widget _makeTestable(Widget child) {
  return DefaultAssetBundle(
    bundle: TestAssetBundle(),
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('OnboardingView', () {
    testWidgets('shows delivery image', (tester) async {
      await tester.pumpWidget(_makeTestable(const OnboardingView()));
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (w) => w is Image && w.image is AssetImage,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows Login and Apply now buttons', (tester) async {
      await tester.pumpWidget(_makeTestable(const OnboardingView()));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
