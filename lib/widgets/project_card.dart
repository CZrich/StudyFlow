import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  final StudyProject project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.course,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 4),
              Text(project.title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 14),
              LinearProgressIndicator(value: project.progress),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${project.completedTasks}/${project.tasks.length} tareas'),
                  Text('${(project.progress * 100).round()}%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
