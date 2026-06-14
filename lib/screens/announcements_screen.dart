import 'package:flutter/material.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Announcements', showBackButton: false),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final announcements = MockDatabase.instance.announcements;

          if (announcements.isEmpty) {
            return const Center(
              child: Text(
                'No announcements yet.',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: announcements.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return AnnouncementCard(announcement: announcements[index]);
            },
          );
        },
      ),
    );
  }
}
