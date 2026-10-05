import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moviles_lab6/main.dart';

void main() {
  testWidgets('Login shows profile screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileLoginApp());

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'alumno@demo.com');
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.tap(find.text('Iniciar sesion'));
    await tester.pumpAndSettle();

    expect(find.text('alumno'), findsWidgets);
    expect(find.text('Foto de perfil cargada'), findsOneWidget);
  });
}
