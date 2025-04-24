import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/question.dart';
import 'screens/home_screen.dart';
import 'screens/add_question_screen.dart';
import 'screens/question_detail_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'services/question_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create instances of services
  final authService = AuthService();
  final questionService = QuestionService();
  
  // Initialize services
  await authService.initialize();
  await questionService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        ChangeNotifierProvider<QuestionService>.value(value: questionService),
      ],
      child: const InterviewApp(),
    ),
  );
}

class InterviewApp extends StatelessWidget {
  const InterviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview Prep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add': (context) => const AddQuestionScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
