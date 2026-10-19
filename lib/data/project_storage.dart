import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/project.dart';

abstract interface class ProjectStorage {
  Future<List<StudyProject>?> load();
  Future<void> save(List<StudyProject> projects);
}

class SharedPreferencesProjectStorage implements ProjectStorage {
  static const _projectsKey = 'study_flow_projects_v1';
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<List<StudyProject>?> load() async {
    final value = await _preferences.getString(_projectsKey);
    if (value == null) return null;

    final decoded = jsonDecode(value) as List;
    return decoded
        .map(
            (project) => StudyProject.fromJson(project as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(List<StudyProject> projects) async {
    final value = jsonEncode(
      projects.map((project) => project.toJson()).toList(),
    );
    await _preferences.setString(_projectsKey, value);
  }
}
