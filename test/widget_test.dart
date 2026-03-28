import 'package:flutter_test/flutter_test.dart';
import 'package:mistral_guide/main.dart';

void main() {
  testWidgets('Mistral Guide smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MistralGuideApp());
    expect(find.text('Accueil'), findsWidgets);
  });
}
