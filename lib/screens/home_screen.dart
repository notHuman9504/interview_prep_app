import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../services/auth_service.dart';
import '../services/question_service.dart';
import 'question_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const QuestionsTab(),
    const ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class QuestionsTab extends StatefulWidget {
  const QuestionsTab({super.key});

  @override
  State<QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<QuestionsTab> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Mobile Development',
    'Web Development',
    'Data Structures',
    'Algorithms',
    'System Design',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    // Get questions from the QuestionService using Provider
    final authService = Provider.of<AuthService>(context);
    final questionService = Provider.of<QuestionService>(context);
    final questions = questionService.questions;
    final isLoading = questionService.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Prep'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showCategoryFilterDialog();
            },
          ),
          if (!authService.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              tooltip: 'Login',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category chip display
                if (_selectedCategory != 'All')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Chip(
                          label: Text(_selectedCategory),
                          onDeleted: () {
                            setState(() {
                              _selectedCategory = 'All';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                
                // Question list
                Expanded(
                  child: questions.isEmpty
                      ? const Center(
                          child: Text(
                            'No questions yet. Add some by tapping the + button!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final question = questions[index];
                            
                            // Skip if filtering by category and doesn't match
                            if (_selectedCategory != 'All' && 
                                question.category != _selectedCategory) {
                              return const SizedBox.shrink();
                            }
                            
                            return QuestionCard(question: question);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showCategoryFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Category'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_categories[index]),
                  onTap: () {
                    setState(() {
                      _selectedCategory = _categories[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDetailScreen(question: question),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      question.category,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                question.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By: ${question.createdBy}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${question.createdAt.day}/${question.createdAt.month}/${question.createdAt.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 