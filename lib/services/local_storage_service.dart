import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._internal();
  static final LocalStorageService instance = LocalStorageService._internal();
  factory LocalStorageService() => instance;

  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyUsers = 'registered_users';

  // Save login session
  Future<void> saveUserSession({
    required String userId,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get saved session
  Future<Map<String, String?>> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_keyUserId),
      'name': prefs.getString(_keyUserName),
      'email': prefs.getString(_keyUserEmail),
    };
  }

  // Clear session on logout
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  // Save a newly registered user to persistent storage
  Future<void> saveRegisteredUser({
    required String id,
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyUsers);
    final List<dynamic> users = existing != null ? json.decode(existing) : [];
    users.add({
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    });
    await prefs.setString(_keyUsers, json.encode(users));
  }

  // Load all registered users from persistent storage
  Future<List<Map<String, dynamic>>> loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyUsers);
    if (existing == null) return [];
    final List<dynamic> users = json.decode(existing);
    return users.cast<Map<String, dynamic>>();
  }
}