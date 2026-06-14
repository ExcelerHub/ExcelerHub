import 'package:flutter_test/flutter_test.dart';

import 'package:excelerate_app/main.dart';

void main() {
  testWidgets('Splash screen shows branding', (WidgetTester tester) async {
    await tester.pumpWidget(const ExcelerHubApp());

    expect(find.text('ExcelerHub'), findsOneWidget);
    expect(find.text('Learn • Grow • Connect'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
