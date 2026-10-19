import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_flow/app.dart';
import 'package:study_flow/data/study_flow_controller.dart';

void main() {
  testWidgets('genera las capturas principales del informe', (tester) async {
    final fontLoader = FontLoader('LiberationSans')
      ..addFont(rootBundle.load('assets/fonts/LiberationSans-Regular.ttf'));
    await fontLoader.load();
    final iconLoader = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('assets/fonts/MaterialIcons-Regular.otf'));
    await iconLoader.load();

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      StudyFlowScope(
        controller: StudyFlowController.withSampleData(),
        child: const StudyFlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/01_inicio_sesion.png'),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Ingresar'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/02_panel_resumen.png'),
    );

    await tester.tap(find.text('Proyectos').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/03_lista_proyectos.png'),
    );

    await tester.tap(find.text('Aplicación multiplataforma'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/04_detalle_proyecto.png'),
    );

    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/05_nueva_tarea.png'),
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/06_perfil.png'),
    );
  });
}
