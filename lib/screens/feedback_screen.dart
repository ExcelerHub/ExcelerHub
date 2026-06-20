import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/app_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class FeedbackScreen extends StatefulWidget {
  final String programName;

  const FeedbackScreen({super.key, required this.programName});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _learnController = TextEditingController();
  final _suggestionsController = TextEditingController();
  final _commentsController = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        final user = AuthService.instance.currentUser;
        if (user == null) return;

        final combinedComments = [
          'What did you learn?: ${_learnController.text.trim()}',
          'Suggestions: ${_suggestionsController.text.trim()}',
          'Comments: ${_commentsController.text.trim()}',
        ].join('\n\n');

        final feedback = FeedbackModel(
          userName: user.name,
          programName: widget.programName,
          rating: _rating.toDouble(),
          comments: combinedComments,
          timestamp: 'June 16, 2026',
        );

        MockDatabase.instance.submitFeedback(feedback);
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you! Feedback submitted successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _learnController.dispose();
    _suggestionsController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Feedback'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Program',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.programName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // 5 Star Rating
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return IconButton(
                      iconSize: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      icon: Icon(
                        _rating >= starValue
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: () => setState(() => _rating = starValue),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // What did you learn?
                const Text(
                  'What did you learn?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _learnController,
                  maxLines: 3,
                  minLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please share what you learned';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Describe key learnings and concepts...',
                  ),
                ),
                const SizedBox(height: 16),

                // Suggestions for improvement
                const Text(
                  'Suggestions for improvement',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _suggestionsController,
                  maxLines: 3,
                  minLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'How can we make this program better?',
                  ),
                ),
                const SizedBox(height: 16),

                // Additional Comments
                const Text(
                  'Additional Comments',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _commentsController,
                  maxLines: 3,
                  minLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Any other thoughts or remarks...',
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                CustomButton(
                  text: 'Submit Feedback',
                  isLoading: _isLoading,
                  onPressed: _submitFeedback,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
