import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class FeedbackScreen extends StatefulWidget {
  final String programName;

  const FeedbackScreen({
    super.key,
    required this.programName,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  int _rating = 4;
  bool _isLoading = false;

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        final user = AuthService.instance.currentUser;
        if (user == null) return;

        final feedback = FeedbackModel(
          userName: user.name,
          programName: widget.programName,
          rating: _rating.toDouble(),
          comments: _feedbackController.text.trim(),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Feedback'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return IconButton(
                      iconSize: 40,
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
                const SizedBox(height: 32),
                const Text(
                  'Your feedback',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 6,
                  minLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Share your experience...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Submit',
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
