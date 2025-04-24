import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

class QuestionService extends ChangeNotifier {
  List<Question> _questions = [];
  bool _isLoading = false;

  // Getters
  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;

  // Initialize the service and load questions from SharedPreferences
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadQuestions();
    } catch (e) {
      debugPrint('Error initializing question service: $e');
      // If loading fails, use mock data as fallback
      _questions = [...mockQuestions];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load questions from SharedPreferences
  Future<void> _loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = prefs.getString('questions');
    
    if (questionsJson == null) {
      // If no data in SharedPreferences, use mock data
      _questions = [...mockQuestions];
      // Save mock data to SharedPreferences
      await _saveQuestions();
    } else {
      final List<dynamic> questionsList = jsonDecode(questionsJson);
      
      _questions = questionsList.map((questionMap) {
        return Question(
          id: questionMap['id'],
          title: questionMap['title'],
          description: questionMap['description'],
          answer: questionMap['answer'],
          category: questionMap['category'],
          createdAt: DateTime.parse(questionMap['createdAt']),
          createdBy: questionMap['createdBy'],
        );
      }).toList();
    }
  }

  // Save questions to SharedPreferences
  Future<void> _saveQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    
    final List<Map<String, dynamic>> questionsList = _questions.map((question) {
      return {
        'id': question.id,
        'title': question.title,
        'description': question.description,
        'answer': question.answer,
        'category': question.category,
        'createdAt': question.createdAt.toIso8601String(),
        'createdBy': question.createdBy,
      };
    }).toList();
    
    await prefs.setString('questions', jsonEncode(questionsList));
  }

  // Add a new question
  Future<void> addQuestion(Question question) async {
    _questions.add(question);
    await _saveQuestions();
    notifyListeners();
  }

  // Get question by ID
  Question? getQuestionById(String id) {
    try {
      return _questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get questions by category
  List<Question> getQuestionsByCategory(String category) {
    return _questions.where((q) => q.category == category).toList();
  }
  
  // Get questions by user ID
  List<Question> getQuestionsByUser(String userId) {
    return _questions.where((q) => q.createdBy == userId).toList();
  }
} 