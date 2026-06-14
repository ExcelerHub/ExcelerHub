import 'package:flutter/material.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/announcement_card.dart';
import '../widgets/custom_app_bar.dart';

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
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.paddingLarge,
              8,
              AppConstants.paddingLarge,
              24,
            ),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              return AnnouncementCard(announcement: announcements[index]);
            },
          );
        },
      ),
    );
  }
}
