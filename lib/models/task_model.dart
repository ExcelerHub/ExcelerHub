class TaskModel {
  final String id;
  final String userId;
  final String title;
  final bool isCompleted;
  final String? programId; // Optional link to program
  final String dueDate;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.isCompleted,
    this.programId,
    required this.dueDate,
  });

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    bool? isCompleted,
    String? programId,
    String? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      programId: programId ?? this.programId,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'isCompleted': isCompleted,
      'programId': programId,
      'dueDate': dueDate,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      programId: map['programId'],
      dueDate: map['dueDate'] ?? 'In 3 days',
    );
  }
}
