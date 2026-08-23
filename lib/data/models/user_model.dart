class UserModel {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['is_active'] ?? true,
    );
  }
}