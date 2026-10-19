import 'package:flutter/material.dart';

import '../data/study_flow_controller.dart';
import '../widgets/project_card.dart';
import 'project_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyFlowScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Hola, Andrea', style: Theme.of(context).textTheme.headlineSmall),
        const Text('Este es el estado de tus trabajos grupales.'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Pendientes',
                value: '${controller.pendingTasks}',
                icon: Icons.pending_actions,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Completadas',
                value: '${controller.completedTasks}',
                icon: Icons.task_alt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Proyectos activos',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final project in controller.projects) ...[
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.onPrimaryContainer),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(label),
          ],
        ),
      ),
    );
  }
}
