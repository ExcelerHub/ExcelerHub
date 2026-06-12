import '../models/feedback_model.dart';

List<FeedbackModel> getDummyFeedback() {
  return [
    FeedbackModel(
      userName: 'Alex Mercer',
      programName: 'UI/UX Design Program',
      rating: 5.0,
      comments: 'Very satisfied! I learned design systems, wireframing, and Figma prototyping. Highly recommend this cohort.',
      timestamp: 'June 05, 2026',
    ),
    FeedbackModel(
      userName: 'Jordan Miller',
      programName: 'Flutter Development Internship',
      rating: 4.0,
      comments: 'The tasks were challenging but extremely rewarding. I finally understood state management and architecture!',
      timestamp: 'June 08, 2026',
    ),
  ];
}
