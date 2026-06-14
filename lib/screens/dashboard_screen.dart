import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_tile.dart';
import '../widgets/announcement_card.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int index, {bool autoFocusProgramsSearch})? onTabSelected;

  const DashboardScreen({
    super.key,
    this.onTabSelected,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _calculateProgress(String userId) {
    final userTasks = MockDatabase.instance.getTasksForUser(userId);
    if (userTasks.isEmpty) return {'percentage': 0.0, 'completed': 0, 'total': 0};

    final completed = userTasks.where((t) => t.isCompleted).length;
    final total = userTasks.length;
    return {
      'percentage': completed / total,
      'completed': completed,
      'total': total,
    };
  }

  void _goToTab(int index, {bool autoFocusProgramsSearch = false}) {
    widget.onTabSelected?.call(index, autoFocusProgramsSearch: autoFocusProgramsSearch);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final user = AuthService.instance.currentUser;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Not authenticated')),
          );
        }

        return ListenableBuilder(
          listenable: MockDatabase.instance,
          builder: (context, _) {
            final progressData = _calculateProgress(user.id);
            final allTasks = MockDatabase.instance.getTasksForUser(user.id);
            final pendingTasks = allTasks.where((t) => !t.isCompleted).take(3).toList();
            final recentAnnouncements = MockDatabase.instance.announcements.take(2).toList();
            final enrolledCount = user.joinedPrograms.length;
            final announcementCount = MockDatabase.instance.announcements.length;

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  user.name.split(' ').first,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _goToTab(4),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () => _goToTab(1, autoFocusProgramsSearch: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: AppColors.textLight, size: 22),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search programs...',
                                  style: TextStyle(color: AppColors.textLight, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          _buildOverviewCard(
                            icon: Icons.school_outlined,
                            label: 'Programs',
                            value: '$enrolledCount',
                            color: const Color(0xff3b82f6),
                            onTap: () => _goToTab(1),
                          ),
                          const SizedBox(width: 10),
                          _buildOverviewCard(
                            icon: Icons.task_alt_outlined,
                            label: 'Pending',
                            value: '${allTasks.where((t) => !t.isCompleted).length}',
                            color: const Color(0xff10b981),
                            onTap: () => _goToTab(2),
                          ),
                          const SizedBox(width: 10),
                          _buildOverviewCard(
                            icon: Icons.campaign_outlined,
                            label: 'Updates',
                            value: '$announcementCount',
                            color: const Color(0xff8b5cf6),
                            onTap: () => _goToTab(3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      ProgressCard(
                        percentage: progressData['percentage'],
                        completedTasks: progressData['completed'],
                        totalTasks: progressData['total'],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.6,
                        children: [
                          _buildShortcutCard(
                            icon: Icons.school_outlined,
                            label: 'Programs',
                            subtitle: 'Browse internships',
                            color: const Color(0xff3b82f6),
                            onTap: () => _goToTab(1),
                          ),
                          _buildShortcutCard(
                            icon: Icons.task_alt_outlined,
                            label: 'Tasks',
                            subtitle: 'Track progress',
                            color: const Color(0xff10b981),
                            onTap: () => _goToTab(2),
                          ),
                          _buildShortcutCard(
                            icon: Icons.campaign_outlined,
                            label: 'Announcements',
                            subtitle: 'Latest updates',
                            color: const Color(0xff8b5cf6),
                            onTap: () => _goToTab(3),
                          ),
                          _buildShortcutCard(
                            icon: Icons.person_outline,
                            label: 'Profile',
                            subtitle: 'Your account',
                            color: const Color(0xfff59e0b),
                            onTap: () => _goToTab(4),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upcoming Tasks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _goToTab(2),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      pendingTasks.isEmpty
                          ? _buildEmptyState(
                              icon: Icons.check_circle_outline,
                              message: 'All caught up! No pending tasks.',
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pendingTasks.length,
                              itemBuilder: (context, index) {
                                return TaskTile(
                                  task: pendingTasks[index],
                                  onToggle: () {
                                    MockDatabase.instance.toggleTaskCompletion(pendingTasks[index].id);
                                  },
                                );
                              },
                            ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Announcements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _goToTab(3),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      recentAnnouncements.isEmpty
                          ? _buildEmptyState(
                              icon: Icons.campaign_outlined,
                              message: 'No announcements yet.',
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recentAnnouncements.length,
                              itemBuilder: (context, index) {
                                return AnnouncementCard(announcement: recentAnnouncements[index]);
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.textLight),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
