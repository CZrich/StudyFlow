enum TaskPriority { low, medium, high }

class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String description;
  final String assignee;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;

  StudyTask copyWith({
    String? title,
    String? description,
    String? assignee,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return StudyTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignee: assignee ?? this.assignee,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'assignee': assignee,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority.name,
        'isCompleted': isCompleted,
      };

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      assignee: json['assignee'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: TaskPriority.values.byName(json['priority'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
