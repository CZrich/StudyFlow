import 'package:flutter/material.dart';

import '../data/study_flow_controller.dart';
import '../models/project.dart';

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key, this.project});

  final StudyProject? project;

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _courseController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _membersController;
  late DateTime _dueDate;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _courseController = TextEditingController(text: project?.course);
    _titleController = TextEditingController(text: project?.title);
    _descriptionController = TextEditingController(text: project?.description);
    _membersController = TextEditingController(
      text: project?.members.join(', ') ?? '',
    );
    _dueDate = project?.dueDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _courseController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (selected != null) setState(() => _dueDate = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = StudyFlowScope.of(context);
    final members = _membersController.text
        .split(',')
        .map((member) => member.trim())
        .where((member) => member.isNotEmpty)
        .toList();
    for (final task in widget.project?.tasks ?? const []) {
      if (!members.contains(task.assignee)) members.add(task.assignee);
    }
    final project = StudyProject(
      id: widget.project?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      course: _courseController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
      members: members,
      tasks: widget.project?.tasks ?? const [],
    );

    if (_isEditing) {
      await controller.updateProject(project);
    } else {
      await controller.addProject(project);
    }
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing
            ? 'Proyecto actualizado correctamente'
            : 'Proyecto creado correctamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar proyecto' : 'Nuevo proyecto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _textField(_courseController, 'Curso'),
            const SizedBox(height: 16),
            _textField(_titleController, 'Nombre del proyecto'),
            const SizedBox(height: 16),
            _textField(_descriptionController, 'Descripción', maxLines: 3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _membersController,
              decoration: const InputDecoration(
                labelText: 'Integrantes separados por comas',
                hintText: 'Andrea, Carlos, María',
              ),
              validator: (value) => (value?.trim().isNotEmpty ?? false)
                  ? null
                  : 'Ingrese al menos un integrante',
            ),
            const SizedBox(height: 16),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              leading: const Icon(Icons.event),
              title: const Text('Fecha de entrega'),
              subtitle: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(_isEditing ? 'Guardar cambios' : 'Crear proyecto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: (value) => (value?.trim().isNotEmpty ?? false)
          ? null
          : 'Este campo es obligatorio',
    );
  }
}
