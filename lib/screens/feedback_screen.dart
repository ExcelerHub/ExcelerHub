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
  final _feedbackController = TextEditingController();
  final _suggestionsController = TextEditingController();
  int _rating = 4;
  bool _isLoading = false;

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        final user = AuthService.instance.currentUser;
        if (user == null) return;

        final combinedComments = [
          'Feedback: ${_feedbackController.text.trim()}',
          'Suggestions: ${_suggestionsController.text.trim()}',
        ].join('\n\n');

        final feedback = FeedbackModel(
          userName: user.name,
          programName: widget.programName,
          rating: _rating.toDouble(),
          comments: combinedComments,
          timestamp: 'June 14, 2026',
        );

        MockDatabase.instance.submitFeedback(feedback);
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback.'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _suggestionsController.dispose();
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
                      padding: const EdgeInsets.symmetric(horizontal: 2),
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
                const Text(
                  'Your Feedback',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 4,
                  minLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please share your feedback';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'What did you learn from this program?',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Suggestions',
                  style: TextStyle(
                    fontSize: 15,
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
                    hintText: 'How can we improve this program?',
                  ),
                ),
                const SizedBox(height: 28),
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
