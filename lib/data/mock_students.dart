import '../models/user_model.dart';

final List<UserModel> mockStudents = [
  UserModel(
    id: 'student-1',
    name: 'Muhammad Ali',
    email: 'ali@student.com',
    role: UserRole.student,
    madrassaName: 'Darul Uloom Karachi',
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
  ),
  UserModel(
    id: 'student-2',
    name: 'Sara Khan',
    email: 'sara@student.com',
    role: UserRole.student,
    madrassaName: 'Jamia Hafsa',
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
  UserModel(
    id: 'student-3',
    name: 'Bilal Ahmed',
    email: 'bilal@student.com',
    role: UserRole.student,
    madrassaName: 'Darul Uloom Lahore',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
];


