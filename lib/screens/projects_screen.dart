import 'package:flutter/material.dart';

import '../data/study_flow_controller.dart';
import '../widgets/project_card.dart';
import 'project_detail_screen.dart';
import 'project_form_screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = StudyFlowScope.of(context).projects;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProjectFormScreen()),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Nuevo proyecto'),
        ),
        const SizedBox(height: 16),
        if (projects.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Todavía no hay proyectos. Cree el primero para comenzar.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        for (final project in projects) ...[
          ProjectCard(
            project: project,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProjectDetailScreen(projectId: project.id),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
