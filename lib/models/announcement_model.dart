class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String date;
  final String category; // e.g., 'Internship', 'Deadline', 'Schedule', 'Webinar'
  final String type;     // e.g., 'Reminder', 'Notification', 'Update'

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'category': category,
      'type': type,
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      category: map['category'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
