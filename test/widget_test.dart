import 'package:flutter_test/flutter_test.dart';
import 'package:unipas/main.dart';

void main() {
  testWidgets('App inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const UnipasApp());
  });
}