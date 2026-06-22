import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'mock_database.dart';
import 'local_storage_service.dart';

class AuthService extends ChangeNotifier {
  AuthService._internal() {
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
        final dbUser = MockDatabase.instance.users
            .firstWhere((u) => u.id == _currentUser!.id);
        _currentUser = dbUser;
        notifyListeners();
      } catch (_) {
        _currentUser = null;
        notifyListeners();
      }
    }
  }

  // Login — saves session to local storage
  Future<bool> login(String email, String password) async {
    final user = MockDatabase.instance.authenticateUser(email, password);
    if (user != null) {
      _currentUser = user;
      await LocalStorageService.instance.saveUserSession(
        userId: user.id,
        name: user.name,
        email: user.email,
      );
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

  // Logout — clears local storage session
  Future<void> logout() async {
    _currentUser = null;
    await LocalStorageService.instance.clearSession();
    notifyListeners();
  }

  // Update profile
  bool updateProfile(String name, String email) {
    if (_currentUser == null) return false;
    final updated = MockDatabase.instance
        .updateUserProfile(_currentUser!.id, name, email);
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