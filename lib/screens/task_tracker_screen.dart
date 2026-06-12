import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_tile.dart';

class TaskTrackerScreen extends StatefulWidget {
  const TaskTrackerScreen({super.key});

  @override
  State<TaskTrackerScreen> createState() => _TaskTrackerScreenState();
}

class _TaskTrackerScreenState extends State<TaskTrackerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Task Tracker'),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final tasks = MockDatabase.instance.getTasksForUser(user.id);
          
          final completedTasks = tasks.where((t) => t.isCompleted).toList();
          final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
          
          final double progressPercentage = tasks.isEmpty 
              ? 0.0 
              : completedTasks.length / tasks.length;

          return Column(
            children: [
              // Header progress block
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: ProgressCard(
                  percentage: progressPercentage,
                  completedTasks: completedTasks.length,
                  totalTasks: tasks.length,
                ),
              ),
              
              // Custom TabBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(color: Colors.grey.shade100, width: 1.5),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium - 2),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'All (${tasks.length})'),
                      Tab(text: 'Pending (${pendingTasks.length})'),
                      Tab(text: 'Done (${completedTasks.length})'),
                    ],
                  ),
                ),
              ),
              
              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // All Tasks
                    _buildTaskList(tasks, 'No tasks assigned yet'),
                    // Pending Tasks
                    _buildTaskList(pendingTasks, 'Hurray! No pending tasks'),
                    // Completed Tasks
                    _buildTaskList(completedTasks, 'Complete tasks to see them here'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskList(List<dynamic> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist,
              size: 56,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final task = list[index];
        return TaskTile(
          task: task,
          onToggle: () {
            MockDatabase.instance.toggleTaskCompletion(task.id);
          },
        );
      },
    );
  }
}
