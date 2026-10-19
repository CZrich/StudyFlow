import 'task.dart';

class StudyProject {
  const StudyProject({
    required this.id,
    required this.course,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.members,
    required this.tasks,
  });

  final String id;
  final String course;
  final String title;
  final String description;
  final DateTime dueDate;
  final List<String> members;
  final List<StudyTask> tasks;

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  double get progress => tasks.isEmpty ? 0 : completedTasks / tasks.length;

  StudyProject copyWith({
    String? course,
    String? title,
    String? description,
    DateTime? dueDate,
    List<String>? members,
    List<StudyTask>? tasks,
  }) {
    return StudyProject(
      id: id,
      course: course ?? this.course,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      members: members ?? this.members,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, Object> toJson() => {
        'id': id,
        'course': course,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'members': members,
        'tasks': tasks.map((task) => task.toJson()).toList(),
      };

  factory StudyProject.fromJson(Map<String, dynamic> json) {
    return StudyProject(
      id: json['id'] as String,
      course: json['course'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      members: List<String>.from(json['members'] as List),
      tasks: (json['tasks'] as List)
          .map((task) => StudyTask.fromJson(task as Map<String, dynamic>))
          .toList(),
    );
  }
}
