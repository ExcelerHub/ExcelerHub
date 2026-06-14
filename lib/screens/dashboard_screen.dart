import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/announcement_card.dart';
import '../widgets/app_card.dart';
import '../widgets/program_card.dart';
import '../widgets/section_header.dart';
import '../widgets/task_tile.dart';
import 'program_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int index, {bool autoFocusProgramsSearch})? onTabSelected;

  const DashboardScreen({super.key, this.onTabSelected});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _goToTab(int index, {bool autoFocusProgramsSearch = false}) {
    widget.onTabSelected?.call(
      index,
      autoFocusProgramsSearch: autoFocusProgramsSearch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final user = AuthService.instance.currentUser;
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Not authenticated')));
        }

        return ListenableBuilder(
          listenable: MockDatabase.instance,
          builder: (context, _) {
            final db = MockDatabase.instance;
            final programs = db.programs;
            final enrolledPrograms = programs
                .where((p) => user.joinedPrograms.contains(p.id))
                .toList();
            final continueProgram = enrolledPrograms.isNotEmpty
                ? enrolledPrograms.first
                : (programs.isNotEmpty ? programs.first : null);
            final previewPrograms = programs.take(2).toList();
            final previewAnnouncements = db.announcements.take(2).toList();
            final pendingTasks = db
                .getTasksForUser(user.id)
                .where((t) => !t.isCompleted)
                .take(2)
                .toList();

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingLarge,
                    12,
                    AppConstants.paddingLarge,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.name.split(' ').first,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.appTagline,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () =>
                            _goToTab(1, autoFocusProgramsSearch: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: AppColors.textLight,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Search programs',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (continueProgram != null) ...[
                        const SectionHeader(title: 'Continue Learning'),
                        const SizedBox(height: 10),
                        AppCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProgramDetailsScreen(
                                  programId: continueProgram.id,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      continueProgram.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      continueProgram.duration,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.textLight,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      SectionHeader(
                        title: 'Programs',
                        actionLabel: 'See all',
                        onAction: () => _goToTab(1),
                      ),
                      const SizedBox(height: 10),
                      ...previewPrograms.map(
                        (program) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ProgramCard(
                            program: program,
                            compact: true,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProgramDetailsScreen(
                                    programId: program.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      SectionHeader(
                        title: 'Announcements',
                        actionLabel: 'See all',
                        onAction: () => _goToTab(3),
                      ),
                      const SizedBox(height: 10),
                      if (previewAnnouncements.isEmpty)
                        const Text(
                          'No announcements yet.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        )
                      else
                        AppCard(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: previewAnnouncements
                                .map(
                                  (a) => AnnouncementCard(
                                    announcement: a,
                                    compact: true,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 16),

                      SectionHeader(
                        title: 'Upcoming Tasks',
                        actionLabel: 'See all',
                        onAction: () => _goToTab(2),
                      ),
                      const SizedBox(height: 10),
                      if (pendingTasks.isEmpty)
                        const Text(
                          'All caught up! No pending tasks.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        )
                      else
                        ...pendingTasks.map(
                          (task) => TaskTile(
                            task: task,
                            compact: true,
                            onToggle: () =>
                                db.toggleTaskCompletion(task.id),
                          ),
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
}
