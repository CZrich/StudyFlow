import 'package:flutter_test/flutter_test.dart';
import 'package:study_flow/data/study_flow_controller.dart';
import 'package:study_flow/models/task.dart';

void main() {
  group('StudyFlowController', () {
    test('calcula las tareas iniciales', () {
      final controller = StudyFlowController.withSampleData();

      expect(controller.projects, hasLength(2));
      expect(controller.completedTasks, 1);
      expect(controller.pendingTasks, 3);
    });

    test('cambia el estado de una tarea', () async {
      final controller = StudyFlowController.withSampleData();

      await controller.toggleTask('p1', 't2');

      expect(controller.completedTasks, 2);
      expect(controller.pendingTasks, 2);
      expect(controller.projectById('p1').progress, closeTo(2 / 3, 0.001));
    });

    test('agrega una tarea al proyecto seleccionado', () async {
      final controller = StudyFlowController.withSampleData();
      final initialCount = controller.projectById('p2').tasks.length;

      await controller.addTask(
        'p2',
        StudyTask(
          id: 'new-task',
          title: 'Preparar exposición',
          description: 'Crear las diapositivas finales.',
          assignee: 'Andrea',
          dueDate: DateTime(2026, 10, 30),
          priority: TaskPriority.high,
        ),
      );

      expect(controller.projectById('p2').tasks, hasLength(initialCount + 1));
      expect(
          controller.projectById('p2').tasks.last.title, 'Preparar exposición');
    });
  });
}
