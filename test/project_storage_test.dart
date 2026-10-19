import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:study_flow/data/project_storage.dart';
import 'package:study_flow/models/project.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('guarda y recupera proyectos del almacenamiento local', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final storage = SharedPreferencesProjectStorage();
    final project = StudyProject(
      id: 'persistent-project',
      course: 'Plataformas Emergentes',
      title: 'Proyecto persistente',
      description: 'Datos de prueba',
      dueDate: DateTime(2026, 11, 1),
      members: const ['Andrea'],
      tasks: const [],
    );

    await storage.save([project]);
    final restored = await storage.load();

    expect(restored, isNotNull);
    expect(restored, hasLength(1));
    expect(restored!.single.id, project.id);
    expect(restored.single.title, project.title);
    expect(restored.single.members, project.members);
  });
}
