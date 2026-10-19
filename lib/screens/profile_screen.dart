import 'package:flutter/material.dart';

import '../data/study_flow_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyFlowScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 44,
          child: Icon(Icons.person, size: 48),
        ),
        const SizedBox(height: 12),
        Text('Andrea Quispe',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
        const Text('estudiante@unsa.edu.pe', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Proyectos activos'),
                trailing: Text('${controller.projects.length}'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.task_alt),
                title: const Text('Tareas completadas'),
                trailing: Text('${controller.completedTasks}'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
