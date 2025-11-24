import 'package:get/get.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';
import '../data/mock_courses.dart';

class CourseController extends GetxController {
  final RxList<CourseModel> courses = <CourseModel>[].obs;
  final RxList<EnrollmentModel> enrollments = <EnrollmentModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadCourses() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      courses.assignAll(mockCourses);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> enrollInCourse(String studentId, String courseId) async {
    final enrollment = EnrollmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: studentId,
      courseId: courseId,
      enrolledAt: DateTime.now(),
    );
    enrollments.add(enrollment);
  }

  Future<void> updateProgress(String enrollmentId, double progress) async {
    final index = enrollments.indexWhere((e) => e.id == enrollmentId);
    if (index != -1) {
      final e = enrollments[index];
      enrollments[index] = EnrollmentModel(
        id: e.id,
        studentId: e.studentId,
        courseId: e.courseId,
        progress: progress,
        enrolledAt: e.enrolledAt,
        completedAt: progress >= 100 ? DateTime.now() : null,
        certificateIssued: progress >= 100,
      );
    }
  }

  List<CourseModel> getEnrolledCourses(String studentId) {
    final ids = enrollments.where((e) => e.studentId == studentId).map((e) => e.courseId).toList();
    return courses.where((c) => ids.contains(c.id)).toList();
  }

  List<CourseModel> getCoursesByCategory(CourseCategory category) {
    return courses.where((c) => c.category == category).toList();
  }
}


