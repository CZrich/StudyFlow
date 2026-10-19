import 'package:flutter/material.dart';

import '../models/project.dart';
import '../models/task.dart';
import 'project_storage.dart';

class StudyFlowController extends ChangeNotifier {
  StudyFlowController(this._projects, {ProjectStorage? storage})
      : _storage = storage;

  static Future<StudyFlowController> load(ProjectStorage storage) async {
    final storedProjects = await storage.load();
    final controller = storedProjects == null
        ? StudyFlowController.withSampleData(storage: storage)
        : StudyFlowController(storedProjects, storage: storage);
    if (storedProjects == null) await controller._persist();
    return controller;
  }

  factory StudyFlowController.withSampleData({ProjectStorage? storage}) {
    final now = DateTime.now();
    return StudyFlowController([
      StudyProject(
        id: 'p1',
        course: 'Plataformas Emergentes',
        title: 'Aplicación multiplataforma',
        description: 'Diseñar e implementar el prototipo del Laboratorio 4.',
        dueDate: now.add(const Duration(days: 8)),
        members: const ['Andrea', 'Carlos', 'María'],
        tasks: [
          StudyTask(
            id: 't1',
            title: 'Diseñar mockups',
            description: 'Definir las pantallas principales de la aplicación.',
            assignee: 'Andrea',
            dueDate: now.add(const Duration(days: 2)),
            priority: TaskPriority.high,
            isCompleted: true,
          ),
          StudyTask(
            id: 't2',
            title: 'Implementar navegación',
            description: 'Conectar el inicio, proyectos y perfil.',
            assignee: 'Carlos',
            dueDate: now.add(const Duration(days: 4)),
            priority: TaskPriority.high,
          ),
          StudyTask(
            id: 't3',
            title: 'Redactar informe',
            description: 'Explicar widgets, layouts y funcionamiento.',
            assignee: 'María',
            dueDate: now.add(const Duration(days: 7)),
            priority: TaskPriority.medium,
          ),
        ],
      ),
      StudyProject(
        id: 'p2',
        course: 'Ingeniería de Software',
        title: 'Modelo de requisitos',
        description: 'Preparar historias de usuario y casos de uso.',
        dueDate: now.add(const Duration(days: 15)),
        members: const ['Andrea', 'Luis'],
        tasks: [
          StudyTask(
            id: 't4',
            title: 'Historias de usuario',
            description: 'Redactar y priorizar el backlog inicial.',
            assignee: 'Luis',
            dueDate: now.add(const Duration(days: 6)),
            priority: TaskPriority.medium,
          ),
        ],
      ),
    ], storage: storage);
  }

  final List<StudyProject> _projects;
  final ProjectStorage? _storage;

  List<StudyProject> get projects => List.unmodifiable(_projects);
  int get pendingTasks => _projects
      .expand((project) => project.tasks)
      .where((task) => !task.isCompleted)
      .length;
  int get completedTasks => _projects
      .expand((project) => project.tasks)
      .where((task) => task.isCompleted)
      .length;

  StudyProject projectById(String id) =>
      _projects.firstWhere((project) => project.id == id);

  Future<void> toggleTask(String projectId, String taskId) async {
    final projectIndex = _projects.indexWhere((item) => item.id == projectId);
    final project = _projects[projectIndex];
    final tasks = project.tasks.map((task) {
      return task.id == taskId
          ? task.copyWith(isCompleted: !task.isCompleted)
          : task;
    }).toList();
    _projects[projectIndex] = project.copyWith(tasks: tasks);
    notifyListeners();
    await _persist();
  }

  Future<void> addTask(String projectId, StudyTask task) async {
    final projectIndex = _projects.indexWhere((item) => item.id == projectId);
    final project = _projects[projectIndex];
    _projects[projectIndex] = project.copyWith(tasks: [...project.tasks, task]);
    notifyListeners();
    await _persist();
  }

  Future<void> updateTask(String projectId, StudyTask task) async {
    final projectIndex = _projects.indexWhere((item) => item.id == projectId);
    final project = _projects[projectIndex];
    final tasks = project.tasks
        .map((current) => current.id == task.id ? task : current)
        .toList();
    _projects[projectIndex] = project.copyWith(tasks: tasks);
    notifyListeners();
    await _persist();
  }

  Future<void> deleteTask(String projectId, String taskId) async {
    final projectIndex = _projects.indexWhere((item) => item.id == projectId);
    final project = _projects[projectIndex];
    final tasks = project.tasks.where((task) => task.id != taskId).toList();
    _projects[projectIndex] = project.copyWith(tasks: tasks);
    notifyListeners();
    await _persist();
  }

  Future<void> addProject(StudyProject project) async {
    _projects.add(project);
    notifyListeners();
    await _persist();
  }

  Future<void> updateProject(StudyProject project) async {
    final index = _projects.indexWhere((current) => current.id == project.id);
    _projects[index] = project;
    notifyListeners();
    await _persist();
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((project) => project.id == projectId);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    await _storage?.save(_projects);
  }
}

class StudyFlowScope extends InheritedNotifier<StudyFlowController> {
  const StudyFlowScope({
    super.key,
    required StudyFlowController controller,
    required super.child,
  }) : super(notifier: controller);

  static StudyFlowController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StudyFlowScope>();
    assert(scope != null, 'StudyFlowScope no está disponible en el contexto.');
    return scope!.notifier!;
  }
}
