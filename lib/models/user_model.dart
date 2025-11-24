enum UserRole { admin, teacher, madrassa, student }

class UserModel {
  final String id, name, email;
  final UserRole role;
  final String? madrassaId, madrassaName;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.madrassaId,
    this.madrassaName,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], name: json['name'], email: json['email'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${json['role']}'),
      madrassaId: json['madrassaId'],
      madrassaName: json['madrassaName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'email': email,
    'role': role.toString().split('.').last,
    'madrassaId': madrassaId, 'madrassaName': madrassaName,
    'createdAt': createdAt.toIso8601String(),
  };
}
