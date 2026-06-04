import 'package:cooper_maratonista/main.dart';
import 'package:cooper_maratonista/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders runner dashboard', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const CooperMaratonistaApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Cooper Maratonista'), findsOneWidget);
    expect(find.text('Iniciar corrida'), findsOneWidget);
    expect(find.text('Complete seu perfil'), findsOneWidget);
    expect(find.text('Resumo'), findsOneWidget);
  });
}
