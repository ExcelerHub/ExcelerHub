import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/skill_chip.dart';
import 'feedback_screen.dart';

class ProgramDetailsScreen extends StatelessWidget {
  final String programId;

  const ProgramDetailsScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Program Details'),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final program =
              MockDatabase.instance.programs.firstWhere((p) => p.id == programId);
          final user = AuthService.instance.currentUser;
          final isJoined =
              user != null && user.joinedPrograms.contains(programId);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(
                            AppConstants.borderRadiusCard,
                          ),
                          bottomRight: Radius.circular(
                            AppConstants.borderRadiusCard,
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 7,
                          child: Image.network(
                            program.imageUrl ?? AppConstants.placeholderImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.15,
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule_outlined,
                                  size: 14,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  program.duration,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  program.startDate,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const _SectionLabel('Description'),
                            const SizedBox(height: 6),
                            Text(
                              program.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const _SectionLabel('Eligibility'),
                            const SizedBox(height: 6),
                            Text(
                              program.eligibility,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const _SectionLabel("Skills You'll Learn"),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: program.skills
                                  .map((skill) => SkillChip(label: skill))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            const _SectionLabel('Learning Outcomes'),
                            const SizedBox(height: 10),
                            ...program.learningOutcomes.map(
                              (outcome) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        outcome,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isJoined) ...[
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FeedbackScreen(
                                        programName: program.title,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.rate_review_outlined, size: 18),
                                label: const Text('Submit Feedback'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingLarge,
                    8,
                    AppConstants.paddingLarge,
                    16,
                  ),
                  child: CustomButton(
                    text: isJoined ? 'Joined' : 'Join Program',
                    onPressed: isJoined || user == null
                        ? null
                        : () {
                            final success = MockDatabase.instance.joinProgram(
                              user.id,
                              programId,
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You joined ${program.title}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
