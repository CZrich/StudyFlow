import 'package:flutter/material.dart';

import 'app.dart';
import 'data/project_storage.dart';
import 'data/study_flow_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await StudyFlowController.load(
    SharedPreferencesProjectStorage(),
  );
  runApp(StudyFlowScope(
    controller: controller,
    child: const StudyFlowApp(),
  ));
}
