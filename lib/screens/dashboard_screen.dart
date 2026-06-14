import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../widgets/announcement_card.dart';
import 'program_details_screen.dart';

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
            final featuredProgram = MockDatabase.instance.programs.isNotEmpty
                ? MockDatabase.instance.programs.first
                : null;
            final recentAnnouncements =
                MockDatabase.instance.announcements.take(3).toList();

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user.name.split(' ').first}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Find your next learning program',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: () => _goToTab(1, autoFocusProgramsSearch: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xfff8fafc),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: AppColors.textLight, size: 22),
                              SizedBox(width: 12),
                              Text(
                                'Search programs',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (featuredProgram != null) ...[
                        const Text(
                          'Featured Program',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Material(
                          color: const Color(0xfff8fafc),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProgramDetailsScreen(
                                    programId: featuredProgram.id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    featuredProgram.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    featuredProgram.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${featuredProgram.duration} · Starts ${featuredProgram.startDate}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Announcements',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _goToTab(2),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('See all'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (recentAnnouncements.isEmpty)
                        const Text(
                          'No announcements yet.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        )
                      else
                        ...recentAnnouncements.map(
                          (announcement) => AnnouncementCard(
                            announcement: announcement,
                          ),
                        ),
                      const SizedBox(height: 16),

                      const Text(
                        'Quick navigation',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _QuickNavButton(
                        icon: Icons.school_outlined,
                        label: 'Browse Programs',
                        onTap: () => _goToTab(1),
                      ),
                      _QuickNavButton(
                        icon: Icons.campaign_outlined,
                        label: 'Announcements',
                        onTap: () => _goToTab(2),
                      ),
                      _QuickNavButton(
                        icon: Icons.person_outline,
                        label: 'My Profile',
                        onTap: () => _goToTab(3),
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

class _QuickNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickNavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textLight,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
