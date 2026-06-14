class ProgramModel {
  final String id;
  final String title;
  final String duration;
  final String description;
  final String startDate;
  final String eligibility;
  final List<String> skills;
  final List<String> learningOutcomes;
  final String mentor;
  final List<String> joinedUsers;
  final String? imageUrl; // optional placeholder helper

  ProgramModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.description,
    required this.startDate,
    required this.eligibility,
    required this.skills,
    required this.learningOutcomes,
    required this.mentor,
    required this.joinedUsers,
    this.imageUrl,
  });

  ProgramModel copyWith({
    String? id,
    String? title,
    String? duration,
    String? description,
    String? startDate,
    String? eligibility,
    List<String>? skills,
    List<String>? learningOutcomes,
    String? mentor,
    List<String>? joinedUsers,
    String? imageUrl,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      eligibility: eligibility ?? this.eligibility,
      skills: skills ?? List.from(this.skills),
      learningOutcomes: learningOutcomes ?? List.from(this.learningOutcomes),
      mentor: mentor ?? this.mentor,
      joinedUsers: joinedUsers ?? List.from(this.joinedUsers),
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'description': description,
      'startDate': startDate,
      'eligibility': eligibility,
      'skills': skills,
      'learningOutcomes': learningOutcomes,
      'mentor': mentor,
      'joinedUsers': joinedUsers,
      'imageUrl': imageUrl,
    };
  }

  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    return ProgramModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? '',
      eligibility: map['eligibility'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      learningOutcomes: List<String>.from(map['learningOutcomes'] ?? []),
      mentor: map['mentor'] ?? '',
      joinedUsers: List<String>.from(map['joinedUsers'] ?? []),
      imageUrl: map['imageUrl'],
    );
  }
}
