import 'package:flutter/material.dart';

import '../data/study_flow_controller.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    required this.projectId,
    this.task,
  });

  final String projectId;
  final StudyTask? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? _assignee;
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title);
    _descriptionController = TextEditingController(text: task?.description);
    _assignee = task?.assignee;
    _priority = task?.priority ?? TaskPriority.medium;
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) setState(() => _dueDate = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final task = StudyTask(
      id: widget.task?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      assignee: _assignee!,
      dueDate: _dueDate,
      priority: _priority,
      isCompleted: widget.task?.isCompleted ?? false,
    );
    final controller = StudyFlowScope.of(context);
    if (_isEditing) {
      await controller.updateTask(widget.projectId, task);
    } else {
      await controller.addTask(widget.projectId, task);
    }
    if (!mounted) return;
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(_isEditing
            ? 'Tarea actualizada correctamente'
            : 'Tarea registrada correctamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = StudyFlowScope.of(context).projectById(widget.projectId);
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar tarea' : 'Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) => (value?.trim().length ?? 0) >= 3
                  ? null
                  : 'Ingrese al menos 3 caracteres',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) => (value?.trim().isNotEmpty ?? false)
                  ? null
                  : 'Ingrese una descripción',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _assignee,
              decoration: const InputDecoration(labelText: 'Responsable'),
              items: project.members
                  .map((member) =>
                      DropdownMenuItem(value: member, child: Text(member)))
                  .toList(),
              onChanged: (value) => setState(() => _assignee = value),
              validator: (value) =>
                  value == null ? 'Seleccione un responsable' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: const [
                DropdownMenuItem(value: TaskPriority.low, child: Text('Baja')),
                DropdownMenuItem(
                    value: TaskPriority.medium, child: Text('Media')),
                DropdownMenuItem(value: TaskPriority.high, child: Text('Alta')),
              ],
              onChanged: (value) => setState(() => _priority = value!),
            ),
            const SizedBox(height: 16),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              leading: const Icon(Icons.event),
              title: const Text('Fecha límite'),
              subtitle:
                  Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Guardar tarea'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
