import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/program_model.dart';
import '../models/task_model.dart';
import '../models/announcement_model.dart';
import '../models/feedback_model.dart';

import '../data/dummy_users.dart';
import '../data/dummy_tasks.dart';
import '../data/dummy_announcements.dart';
import '../data/dummy_feedback.dart';
import 'mock_api_service.dart';
import 'local_storage_service.dart';

class MockDatabase extends ChangeNotifier {
  MockDatabase._internal();
  static final MockDatabase instance = MockDatabase._internal();
  factory MockDatabase() => instance;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  final List<UserModel> _users = [];
  final List<ProgramModel> _programs = [];
  final List<TaskModel> _tasks = [];
  final List<AnnouncementModel> _announcements = [];
  final List<FeedbackModel> _feedbacks = [];

  Future<void> init() async {
    if (_isLoaded) return;
    _isLoaded = true;
    _users.clear();

    // Load dummy users first
    for (final u in getDummyUsers()) {
      _users.add(u);
    }

    // Load saved registered users from local storage
    final savedUsers =
        await LocalStorageService.instance.loadRegisteredUsers();
    for (final u in savedUsers) {
      final exists = _users.any((e) => e.email == u['email']);
      if (!exists) {
        _users.add(UserModel(
          id: u['id'] ?? 'user_${_users.length + 1}',
          name: u['name'] ?? '',
          email: u['email'] ?? '',
          password: u['password'] ?? '',
          joinedPrograms: [],
          completedPrograms: [],
          achievements: ['New Account Created'],
          skills: [],
        ));
      }
    }

    _programs.addAll(await MockApiService.instance.fetchPrograms());
    _tasks.addAll(getDummyTasks());
    _announcements.addAll(getDummyAnnouncements());
    _feedbacks.addAll(getDummyFeedback());
    notifyListeners();
  }

  // Getters
  List<UserModel> get users => List.unmodifiable(_users);
  List<ProgramModel> get programs => List.unmodifiable(_programs);
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<AnnouncementModel> get announcements =>
      List.unmodifiable(_announcements);
  List<FeedbackModel> get feedbacks => List.unmodifiable(_feedbacks);

  // AUTHENTICATION & USER MANAGEMENT
  UserModel? authenticateUser(String email, String password) {
    try {
      final user = _users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.trim().toLowerCase() &&
            u.password == password,
      );
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<UserModel?> registerUser(
      String name, String email, String password) async {
    final exists = _users
        .any((u) => u.email.toLowerCase() == email.trim().toLowerCase());
    if (exists) return null;

    final newId = 'user_${_users.length + 1}';
    final newUser = UserModel(
      id: newId,
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      joinedPrograms: [],
      completedPrograms: [],
      achievements: ['New Account Created'],
      skills: [],
    );

    _users.add(newUser);

    // Save to local storage so user persists after app restart
    await LocalStorageService.instance.saveRegisteredUser(
      id: newId,
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );

    notifyListeners();
    return newUser;
  }

  UserModel? updateUserProfile(String userId, String name, String email) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index == -1) return null;

    final updatedUser = _users[index].copyWith(
      name: name.trim(),
      email: email.trim().toLowerCase(),
    );
    _users[index] = updatedUser;

    notifyListeners();
    return updatedUser;
  }

  // PROGRAM MANAGEMENT
  bool joinProgram(String userId, String programId) {
    final userIndex = _users.indexWhere((u) => u.id == userId);
    final progIndex = _programs.indexWhere((p) => p.id == programId);

    if (userIndex == -1 || progIndex == -1) return false;

    final user = _users[userIndex];
    final program = _programs[progIndex];

    if (user.joinedPrograms.contains(programId)) return true;

    final updatedJoinedPrograms =
        List<String>.from(user.joinedPrograms)..add(programId);
    final achievements = List<String>.from(user.achievements);
    if (achievements.contains('New Account Created')) {
      achievements.remove('New Account Created');
    }
    achievements.add('Enrolled in ${program.title.split(' ').first}');

    _users[userIndex] = user.copyWith(
      joinedPrograms: updatedJoinedPrograms,
      achievements: achievements.toSet().toList(),
    );

    final updatedJoinedUsers =
        List<String>.from(program.joinedUsers)..add(userId);
    _programs[progIndex] =
        program.copyWith(joinedUsers: updatedJoinedUsers);

    final templates = getTaskTemplates();
    for (int i = 0; i < templates.length; i++) {
      final title = templates[i];
      String dueDate;
      if (i == 0) {
        dueDate = 'In 2 days';
      } else if (i == 1) {
        dueDate = 'In 5 days';
      } else if (i == 2) {
        dueDate = 'In 1 week';
      } else if (i == 3) {
        dueDate = 'In 2 weeks';
      } else {
        dueDate = 'In 3 weeks';
      }

      _tasks.add(TaskModel(
        id: 'task_${_tasks.length + 1}',
        userId: userId,
        title: '$title (${program.title.split(' ').first})',
        isCompleted: false,
        programId: programId,
        dueDate: dueDate,
      ));
    }

    notifyListeners();
    return true;
  }

  bool leaveProgram(String userId, String programId) {
    final userIndex = _users.indexWhere((u) => u.id == userId);
    final progIndex = _programs.indexWhere((p) => p.id == programId);

    if (userIndex == -1 || progIndex == -1) return false;

    final user = _users[userIndex];
    final program = _programs[progIndex];

    final updatedJoinedPrograms =
        List<String>.from(user.joinedPrograms)..remove(programId);
    final updatedCompletedPrograms =
        List<String>.from(user.completedPrograms)..remove(programId);

    final firstWord = program.title.split(' ').first;
    final achievements = List<String>.from(user.achievements)
      ..removeWhere(
          (a) => a.contains(firstWord) || a.contains(program.title));

    _users[userIndex] = user.copyWith(
      joinedPrograms: updatedJoinedPrograms,
      completedPrograms: updatedCompletedPrograms,
      achievements: achievements.toSet().toList(),
    );

    final updatedJoinedUsers =
        List<String>.from(program.joinedUsers)..remove(userId);
    _programs[progIndex] =
        program.copyWith(joinedUsers: updatedJoinedUsers);

    _tasks.removeWhere(
        (t) => t.userId == userId && t.programId == programId);

    notifyListeners();
    return true;
  }

  // TASK MANAGEMENT
  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    _tasks[index] = updatedTask;

    if (updatedTask.isCompleted && updatedTask.programId != null) {
      _checkAndAwardCompletion(updatedTask.userId, updatedTask.programId!);
    }

    notifyListeners();
  }

  void _checkAndAwardCompletion(String userId, String programId) {
    final userTasks = _tasks
        .where((t) => t.userId == userId && t.programId == programId)
        .toList();
    if (userTasks.isNotEmpty && userTasks.every((t) => t.isCompleted)) {
      final userIndex = _users.indexWhere((u) => u.id == userId);
      if (userIndex != -1) {
        final user = _users[userIndex];
        if (!user.completedPrograms.contains(programId)) {
          final completed =
              List<String>.from(user.completedPrograms)..add(programId);
          final prog = _programs.firstWhere((p) => p.id == programId);
          final achievements = List<String>.from(user.achievements)
            ..add('Completed ${prog.title}');

          _users[userIndex] = user.copyWith(
            completedPrograms: completed,
            achievements: achievements.toSet().toList(),
          );
        }
      }
    }
  }

  List<TaskModel> getTasksForUser(String userId) {
    return _tasks.where((t) => t.userId == userId).toList();
  }

  // FEEDBACK MANAGEMENT
  void submitFeedback(FeedbackModel feedback) {
    _feedbacks.add(feedback);
    notifyListeners();
  }
}