import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madressa_learning_platform/models/lecture_model.dart';
import 'package:get/get.dart';
import 'package:madressa_learning_platform/screens/course/unified/course_content_detail_screen.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';

class StudentAppliedCoursesScreen extends StatelessWidget {
  const StudentAppliedCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put(CourseController(), permanent: true);
    final authController = Get.put(AuthController(), permanent: true);
    final user = authController.currentUser.value;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Please login', style: GoogleFonts.inter(fontSize: 18)),
        ),
      );
    }

    if (courseController.courses.isEmpty && !courseController.isLoading.value) {
      courseController.loadCourses();
    }

    return Obx(() {
      final enrolledCourses = courseController.getEnrolledCourses(user.id);
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'My Courses',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF1967D2),
        ),
        body:
            courseController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : enrolledCourses.isEmpty
                ? _buildEmptyState()
                : _buildCoursesList(enrolledCourses, user, context),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No enrolled courses',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enroll in courses to start learning',
            style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List courses, UserModel user, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCourseCard(course, user, context),
        );
      },
    );
  }

  Widget _buildCourseCard(
    dynamic course,
    UserModel user,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    CourseContentDetailScreen(course: course, userId: user.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1967D2), const Color(0xFF1557B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  if (course.imageUrl != null && course.imageUrl!.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          course.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatChip(
                      Icons.play_circle_outline,
                      '${course.lectures.length} lectures',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatChip(
                      Icons.category_outlined,
                      course.category.toString().split('.').last,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}


