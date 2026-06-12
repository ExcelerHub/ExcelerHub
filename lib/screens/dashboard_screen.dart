import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_tile.dart';
import '../widgets/announcement_card.dart';
import 'program_listing_screen.dart';
import 'task_tracker_screen.dart';
import 'profile_screen.dart';
import 'announcements_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Calculate user progress
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

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Welcome Banner
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ProfileScreen()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 2. Search Bar Placeholder/Search Button
                      GestureDetector(
                        onTap: () {
                          // Search navigates to programs or announcements
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ProgramListingScreen(autoFocusSearch: true)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.01),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: AppColors.textLight),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search programs, tasks, announcements...',
                                  style: TextStyle(color: AppColors.textLight, fontSize: 14),
                                ),
                              ),
                              Icon(Icons.tune, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 3. Learning Progress Card
                      ProgressCard(
                        percentage: progressData['percentage'],
                        completedTasks: progressData['completed'],
                        totalTasks: progressData['total'],
                      ),
                      const SizedBox(height: 24),

                      // Quick Access Grid Section
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
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: [
                          _buildQuickAccessCard(
                            context,
                            icon: Icons.school_outlined,
                            label: 'Programs',
                            color: const Color(0xff3b82f6),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ProgramListingScreen()),
                            ),
                          ),
                          _buildQuickAccessCard(
                            context,
                            icon: Icons.task_alt_outlined,
                            label: 'Tasks',
                            color: const Color(0xff10b981),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const TaskTrackerScreen()),
                            ),
                          ),
                          _buildQuickAccessCard(
                            context,
                            icon: Icons.person_outline,
                            label: 'Profile',
                            color: const Color(0xfff59e0b),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ProfileScreen()),
                            ),
                          ),
                          _buildQuickAccessCard(
                            context,
                            icon: Icons.campaign_outlined,
                            label: 'Announce',
                            color: const Color(0xff8b5cf6),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const AnnouncementsScreen()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 4. Upcoming Tasks Section
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
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const TaskTrackerScreen()),
                            ),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      pendingTasks.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.check_circle_outline, size: 36, color: AppColors.success),
                                  SizedBox(height: 8),
                                  Text(
                                    'All caught up! No pending tasks.',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                  ),
                                ],
                              ),
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

                      // 5. Upcoming Events Section
                      const Text(
                        'Upcoming Internship Events',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 110,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildEventCard(
                              title: 'Orientation Cohort Kickoff',
                              date: 'June 18',
                              time: '10:00 AM',
                              type: 'LIVE SESSION',
                              icon: Icons.diversity_3_outlined,
                            ),
                            _buildEventCard(
                              title: 'Technical Overview (Flutter)',
                              date: 'June 20',
                              time: '3:00 PM',
                              type: 'WORKSHOP',
                              icon: Icons.code,
                            ),
                            _buildEventCard(
                              title: 'AI/ML Projects Deep-dive',
                              date: 'June 24',
                              time: '11:00 AM',
                              type: 'SEMINAR',
                              icon: Icons.psychology_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 6. Recent Announcements Section
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
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const AnnouncementsScreen()),
                            ),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
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

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        side: BorderSide(color: Colors.grey.shade100, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String time,
    required String type,
    required IconData icon,
  }) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14, bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(icon, size: 14, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '$date at $time',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
