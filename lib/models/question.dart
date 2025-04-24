class Question {
  final String id;
  final String title;
  final String description;
  final String answer;
  final String category;
  final DateTime createdAt;
  final String createdBy;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.answer,
    required this.category,
    required this.createdAt,
    required this.createdBy,
  });
}

// Mock data for development
List<Question> mockQuestions = [
  Question(
    id: '1',
    title: 'What is Flutter?',
    description: 'Explain what Flutter is and how it works.',
    answer: 'Flutter is Google\'s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. It uses the Dart programming language and provides rich customizable widgets for building native interfaces.',
    category: 'Mobile Development',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    createdBy: 'John Smith',
  ),
  Question(
    id: '2',
    title: 'Explain REST API',
    description: 'What is a REST API and what are its principles?',
    answer: 'REST (Representational State Transfer) is an architectural style for designing networked applications. RESTful APIs use HTTP requests to perform CRUD operations. The main principles include statelessness, client-server architecture, cacheability, layered system, uniform interface, and code on demand.',
    category: 'Web Development',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    createdBy: 'Emma Watson',
  ),
]; 