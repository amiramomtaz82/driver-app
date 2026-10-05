import 'package:driver_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp widget smoke test', (WidgetTester tester) async {
    // Verify MyApp can be instantiated
    const app = MyApp();
    expect(app, isNotNull);
  });
}
