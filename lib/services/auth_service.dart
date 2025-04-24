import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final _uuid = const Uuid();

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Initialize the service
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadCurrentUser();
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load current user from SharedPreferences
  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    
    if (userJson != null) {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      _currentUser = User.fromJson(userData);
    }
  }

  // Save current user to SharedPreferences
  Future<void> _saveCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_currentUser != null) {
      final userJson = jsonEncode(_currentUser!.toJson());
      await prefs.setString('current_user', userJson);
    } else {
      await prefs.remove('current_user');
    }
  }

  // Register a new user
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, you would check if the email already exists
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);

      // Check if email already exists
      if (users.containsKey(email)) {
        return false;
      }

      // Create new user
      final newUser = User(
        id: _uuid.v4(),
        name: name,
        email: email,
        password: password,
      );

      // Add to users map
      users[email] = newUser.toJson();
      await prefs.setString('users', jsonEncode(users));

      // Set as current user
      _currentUser = newUser;
      await _saveCurrentUser();
      
      return true;
    } catch (e) {
      debugPrint('Error registering user: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);

      // Check if email exists
      if (!users.containsKey(email)) {
        return false;
      }

      // Get user and check password
      final userData = users[email];
      if (userData['password'] != password) {
        return false;
      }

      // Set as current user
      _currentUser = User.fromJson(userData);
      await _saveCurrentUser();
      
      return true;
    } catch (e) {
      debugPrint('Error logging in: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = null;
      await _saveCurrentUser();
    } catch (e) {
      debugPrint('Error logging out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 