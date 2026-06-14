import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/progress_card.dart';
import '../widgets/section_header.dart';
import '../widgets/task_tile.dart';

class TaskTrackerScreen extends StatelessWidget {
  const TaskTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not authenticated')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Tasks', showBackButton: false),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final tasks = MockDatabase.instance.getTasksForUser(user.id);
          final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
          final completedTasks = tasks.where((t) => t.isCompleted).toList();
          final progress = tasks.isEmpty
              ? 0.0
              : completedTasks.length / tasks.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.paddingLarge,
              12,
              AppConstants.paddingLarge,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressCard(
                  percentage: progress,
                  completedTasks: completedTasks.length,
                  totalTasks: tasks.length,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Pending Tasks (${pendingTasks.length})',
                ),
                const SizedBox(height: 10),
                if (pendingTasks.isEmpty)
                  const Text(
                    'No pending tasks. Great job!',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...pendingTasks.map(
                    (task) => TaskTile(
                      task: task,
                      onToggle: () =>
                          MockDatabase.instance.toggleTaskCompletion(task.id),
                    ),
                  ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Completed Tasks (${completedTasks.length})',
                ),
                const SizedBox(height: 10),
                if (completedTasks.isEmpty)
                  const Text(
                    'Completed tasks will appear here.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...completedTasks.map(
                    (task) => TaskTile(
                      task: task,
                      onToggle: () =>
                          MockDatabase.instance.toggleTaskCompletion(task.id),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
