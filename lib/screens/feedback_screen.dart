import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/auth_service.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
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
  final _q1Controller = TextEditingController();
  final _q2Controller = TextEditingController();
  final _q3Controller = TextEditingController();
  
  double _rating = 5.0; // default to 5 star
  bool _isLoading = false;

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        final user = AuthService.instance.currentUser;
        if (user == null) return;

        // Concatenate comments from all three questions
        final commentsText = 
            'Q1 (Satisfaction): ${_q1Controller.text.trim()}\n'
            'Q2 (Learned): ${_q2Controller.text.trim()}\n'
            'Q3 (Suggestions): ${_q3Controller.text.trim()}';

        final feedback = FeedbackModel(
          userName: user.name,
          programName: widget.programName,
          rating: _rating,
          comments: commentsText,
          timestamp: 'June 12, 2026', // dynamic date could be fetched but static mock date matches formatting
        );

        MockDatabase.instance.submitFeedback(feedback);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feedback submitted successfully! Thank you.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _q1Controller.dispose();
    _q2Controller.dispose();
    _q3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Submit Feedback'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Program Name banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'YOU ARE REVIEWING',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.programName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Star Rating Selection
                const Text(
                  'Program Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starVal = index + 1.0;
                    return IconButton(
                      icon: Icon(
                        _rating >= starVal ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = starVal;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                
                // Question 1: How satisfied are you?
                const Text(
                  '1. How satisfied are you with this program?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _q1Controller,
                  maxLines: 2,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please answer this question' : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Highly satisfied, the mentorship was fantastic...',
                  ),
                ),
                const SizedBox(height: 20),
                
                // Question 2: What did you learn?
                const Text(
                  '2. What did you learn?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _q2Controller,
                  maxLines: 3,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please answer this question' : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Learned clean architecture, Flutter widgets, and REST integrations...',
                  ),
                ),
                const SizedBox(height: 20),
                
                // Question 3: Suggestions?
                const Text(
                  '3. Suggestions for improvement?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _q3Controller,
                  maxLines: 2,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please answer this question' : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g., More live coding sessions would be great...',
                  ),
                ),
                const SizedBox(height: 32),
                
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
