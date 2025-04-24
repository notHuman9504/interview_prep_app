class User {
  final String id;
  final String name;
  final String email;
  final String password; // In a real app, you would never store plaintext passwords

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Convert user to a map for storing in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Create a user from a map (from SharedPreferences)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
} 