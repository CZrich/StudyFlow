import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_flow/app.dart';
import 'package:study_flow/data/study_flow_controller.dart';

void main() {
  testWidgets('permite ingresar y muestra el resumen', (tester) async {
    await tester.pumpWidget(
      StudyFlowScope(
        controller: StudyFlowController.withSampleData(),
        child: const StudyFlowApp(),
      ),
    );

    expect(find.text('StudyFlow'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Andrea'), findsOneWidget);
    expect(find.text('Proyectos activos'), findsOneWidget);
  });
}
