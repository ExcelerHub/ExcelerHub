class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final List<String> joinedPrograms;
  final List<String> completedPrograms;
  final List<String> achievements;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.joinedPrograms,
    required this.completedPrograms,
    required this.achievements,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    List<String>? joinedPrograms,
    List<String>? completedPrograms,
    List<String>? achievements,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      joinedPrograms: joinedPrograms ?? List.from(this.joinedPrograms),
      completedPrograms: completedPrograms ?? List.from(this.completedPrograms),
      achievements: achievements ?? List.from(this.achievements),
    );
  }

  // Convert to Map for potential database serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'joinedPrograms': joinedPrograms,
      'completedPrograms': completedPrograms,
      'achievements': achievements,
    };
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      joinedPrograms: List<String>.from(map['joinedPrograms'] ?? []),
      completedPrograms: List<String>.from(map['completedPrograms'] ?? []),
      achievements: List<String>.from(map['achievements'] ?? []),
    );
  }
}
