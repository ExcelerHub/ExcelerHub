import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'mock_database.dart';

class AuthService extends ChangeNotifier {
  // Singleton Pattern
  AuthService._internal() {
    // Listen to mock database changes to keep currentUser session in sync
    MockDatabase.instance.addListener(_syncUserSession);
  }
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void _syncUserSession() {
    if (_currentUser != null) {
      try {
        final dbUser = MockDatabase.instance.users.firstWhere((u) => u.id == _currentUser!.id);
        if (dbUser.name != _currentUser!.name ||
            dbUser.email != _currentUser!.email ||
            dbUser.joinedPrograms.length != _currentUser!.joinedPrograms.length ||
            dbUser.completedPrograms.length != _currentUser!.completedPrograms.length ||
            dbUser.achievements.length != _currentUser!.achievements.length) {
          _currentUser = dbUser;
          notifyListeners();
        }
      } catch (_) {
        // user was deleted or not found
        _currentUser = null;
        notifyListeners();
      }
    }
  }

  // Login
  bool login(String email, String password) {
    final user = MockDatabase.instance.authenticateUser(email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Register
  bool register(String name, String email, String password) {
    final user = MockDatabase.instance.registerUser(name, email, password);
    return user != null;
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Manual update profile
  bool updateProfile(String name, String email) {
    if (_currentUser == null) return false;
    final updated = MockDatabase.instance.updateUserProfile(_currentUser!.id, name, email);
    if (updated != null) {
      _currentUser = updated;
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    MockDatabase.instance.removeListener(_syncUserSession);
    super.dispose();
  }
}
