import '../models/user_model.dart';

final List<UserModel> mockTeachers = [
  UserModel(
    id: 'teacher-1',
    name: 'Arham',
    email: 'teacher1@demo.com',
    role: UserRole.teacher,
    madrassaName: 'Darul Uloom Karachi',
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
  ),
  UserModel(
    id: 'teacher-2',
    name: 'Fatima Noor',
    email: 'teacher2@demo.com',
    role: UserRole.teacher,
    madrassaName: 'Jamia Hafsa',
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  ),
  UserModel(
    id: 'teacher-3',
    name: 'Usman Ali',
    email: 'teacher3@demo.com',
    role: UserRole.teacher,
    madrassaName: 'Darul Uloom Lahore',
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
  ),
];
