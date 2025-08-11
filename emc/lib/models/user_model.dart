class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String? department;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.department,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      department: data['department'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'department': department,
    };
  }
}
