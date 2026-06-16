import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/progress_card.dart';
import '../widgets/section_header.dart';
import '../widgets/task_tile.dart';
import '../widgets/custom_button.dart';
import 'main_shell.dart';

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
      appBar: const CustomAppBar(title: 'Tasks', showBackButton: true),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final db = MockDatabase.instance;
          final tasks = db.getTasksForUser(user.id);
          final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
          final completedTasks = tasks.where((t) => t.isCompleted).toList();
          final progress = tasks.isEmpty
              ? 0.0
              : completedTasks.length / tasks.length;

          // If the user has not joined any programs or has no tasks
          if (user.joinedPrograms.isEmpty || tasks.isEmpty) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      size: 72,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Active Tasks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "You haven't joined any learning programs yet.\n"
                      "Join a program to unlock learning tasks, progress tracking, and activities.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      text: 'Browse Programs',
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const MainShell(initialIndex: 1)),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          // Otherwise show tasks list
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No pending tasks. Great job!',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  ...pendingTasks.map(
                    (task) => TaskTile(
                      task: task,
                      onToggle: () => db.toggleTaskCompletion(task.id),
                    ),
                  ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Completed Tasks (${completedTasks.length})',
                ),
                const SizedBox(height: 10),
                if (completedTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Completed tasks will appear here.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  ...completedTasks.map(
                    (task) => TaskTile(
                      task: task,
                      onToggle: () => db.toggleTaskCompletion(task.id),
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
