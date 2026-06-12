class FeedbackModel {
  final String userName;
  final String programName;
  final double rating; // 1 to 5 stars
  final String comments; // Combined suggestions and learnings
  final String timestamp;

  FeedbackModel({
    required this.userName,
    required this.programName,
    required this.rating,
    required this.comments,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'programName': programName,
      'rating': rating,
      'comments': comments,
      'timestamp': timestamp,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      userName: map['userName'] ?? '',
      programName: map['programName'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comments: map['comments'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }
}
