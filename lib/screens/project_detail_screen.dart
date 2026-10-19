import 'package:flutter/material.dart';

import '../data/study_flow_controller.dart';
import '../models/task.dart';
import 'project_form_screen.dart';
import 'task_form_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  @override
  Widget build(BuildContext context) {
    final controller = StudyFlowScope.of(context);
    final project = controller.projectById(projectId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del proyecto'),
        actions: [
          IconButton(
            tooltip: 'Editar proyecto',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProjectFormScreen(project: project),
              ),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Eliminar proyecto',
            onPressed: () => _confirmDeleteProject(
              context,
              controller,
              project.id,
            ),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TaskFormScreen(projectId: projectId)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Text(project.course,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          Text(project.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(project.description),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: project.progress),
          const SizedBox(height: 8),
          Text('${(project.progress * 100).round()}% completado'),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.event, size: 18),
                label: Text('Entrega: ${_date(project.dueDate)}'),
              ),
              for (final member in project.members)
                Chip(
                  avatar:
                      const CircleAvatar(child: Icon(Icons.person, size: 16)),
                  label: Text(member),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Tareas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final task in project.tasks)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: CheckboxListTile(
                value: task.isCompleted,
                onChanged: (_) => controller.toggleTask(project.id, task.id),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                    '${task.assignee} · ${_priority(task.priority)} · ${_date(task.dueDate)}'),
                secondary: PopupMenuButton<String>(
                  tooltip: 'Acciones de la tarea',
                  onSelected: (action) {
                    if (action == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskFormScreen(
                            projectId: project.id,
                            task: task,
                          ),
                        ),
                      );
                    } else {
                      _confirmDeleteTask(
                        context,
                        controller,
                        project.id,
                        task.id,
                      );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar')),
                    PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _priority(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'Baja',
      TaskPriority.medium => 'Media',
      TaskPriority.high => 'Alta',
    };
  }

  Future<void> _confirmDeleteProject(
    BuildContext context,
    StudyFlowController controller,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar proyecto'),
        content: const Text(
          'Se eliminarán también todas sus tareas. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.pop(context);
    await controller.deleteProject(id);
  }

  Future<void> _confirmDeleteTask(
    BuildContext context,
    StudyFlowController controller,
    String projectId,
    String taskId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Desea eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteTask(projectId, taskId);
    }
  }
}
