import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:madressa_learning_platform/screens/auth/login_screen.dart';
import '../models/user_model.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/teacher/teacher_dashboard_screen.dart';
import '../screens/madrassa/madrassa_dashboard_screen.dart';
import '../screens/student/student_dashboard_screen.dart';

class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  bool get isAuthenticated => currentUser.value != null;

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      UserRole role;
      if (email.contains('admin')) {
        role = UserRole.admin;
      } else if (email.contains('teacher')) {
        role = UserRole.teacher;
      } else if (email.contains('madrassa')) {
        role = UserRole.madrassa;
      } else {
        role = UserRole.student;
      }

      String userId = '1';
      if (role == UserRole.teacher) {
        if (email.contains('teacher1') || email.contains('teacher-1')) {
          userId = 'teacher-1';
        } else if (email.contains('teacher2') || email.contains('teacher-2')) {
          userId = 'teacher-2';
        } else if (email.contains('teacher3') || email.contains('teacher-3')) {
          userId = 'teacher-3';
        } else {
          userId = 'teacher-1';
        }
      } else if (role == UserRole.student) {
        userId = 'student-1';
      } else if (role == UserRole.madrassa) {
        userId = 'madrassa-1';
      }

      currentUser.value = UserModel(
        id: userId,
        name: 'Muhammad Arham',
        email: email,
        role: role,
        madrassaId: role == UserRole.student ? 'madrassa-123' : null,
        madrassaName:
            role == UserRole.madrassa ? 'Jamia Islamia Bahawalpur' : null,
        createdAt: DateTime.now(),
      );

      _storage.write('userId', currentUser.value!.id);
      _storage.write('userEmail', currentUser.value!.email);
      _storage.write('userRole', role.toString().split('.').last);

      _navigateBasedOnRole();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    UserRole role,
    String? madrassaName,
    String? madrassaId,
  ) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      currentUser.value = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        madrassaName: madrassaName,
        madrassaId: madrassaId,
        createdAt: DateTime.now(),
      );
      _storage.write('userId', currentUser.value!.id);
      _storage.write('userEmail', currentUser.value!.email);
      _storage.write('userRole', role.toString().split('.').last);
      _navigateBasedOnRole();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    await _storage.erase();
    Get.offAll(
      () => const LoginScreen(),
    ); // or a Login screen if present
  }

  Future<void> checkAuthStatus() async {
    final userId = _storage.read('userId');
    final userEmail = _storage.read('userEmail');
    final userRole = _storage.read('userRole');
    if (userId != null && userEmail != null && userRole != null) {
      currentUser.value = UserModel(
        id: userId,
        name: 'User',
        email: userEmail,
        role: UserRole.values.firstWhere(
          (e) => e.toString().split('.').last == userRole,
          orElse: () => UserRole.student,
        ),
        createdAt: DateTime.now(),
      );
      _navigateBasedOnRole();
    }
  }

  void _navigateBasedOnRole() {
    final user = currentUser.value;
    if (user == null) return;
    Widget screen;
    switch (user.role) {
      case UserRole.admin:
        screen = const AdminDashboardScreen();
        break;
      case UserRole.teacher:
        screen = const TeacherDashboardScreen();
        break;
      case UserRole.madrassa:
        screen = MadrassaDashboardScreen();
        break;
      case UserRole.student:
      default:
        screen = const StudentDashboardScreen();
        break;
    }
    Get.offAll(() => screen);
  }
}
