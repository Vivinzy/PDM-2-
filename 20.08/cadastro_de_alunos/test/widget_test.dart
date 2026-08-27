import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cadastro_de_alunos/main.dart';

void main() {
  testWidgets('deve cadastrar um aluno e exibir na lista', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Cadastro de Alunos'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Maria');
    await tester.enterText(find.byType(TextField).at(1), '20');
    await tester.enterText(find.byType(TextField).at(2), 'ADS');

    await tester.tap(find.text('Cadastrar'));
    await tester.pump();

    expect(find.text('Maria'), findsOneWidget);
    expect(find.text('Idade: 20 | Curso: ADS'), findsOneWidget);
  });
}
