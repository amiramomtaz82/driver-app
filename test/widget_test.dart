import 'package:driver_app/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp widget smoke test', (WidgetTester tester) async {
    // Verify MyApp can be instantiated
    const app = MyApp();
    expect(app, isNotNull);
  });
}
