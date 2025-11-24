import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:madressa_learning_platform/controllers/madrassa_controller.dart';
import 'package:madressa_learning_platform/models/course_model.dart';
import 'package:madressa_learning_platform/screens/madrassa/madrassa_course_manage_screen.dart';
import '../../controllers/auth_controller.dart';

class MadrassaDashboardScreen extends StatelessWidget {
  MadrassaDashboardScreen({Key? key}) : super(key: key);

  final AuthController _authController = Get.put(
    AuthController(),
    permanent: true,
  );
  final MadrassaCoursesController _coursesController = Get.put(
    MadrassaCoursesController(),
  );

  @override
  Widget build(BuildContext context) {
    _coursesController.loadDemoData();
    final user = _authController.currentUser.value;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Madrassa Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.teal.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome & statistics
                _SectionHeader(
                  icon: Icons.apartment_rounded,
                  iconColor: Colors.green,
                  title: user?.name ?? 'Madrassa',
                  subtitle: 'Manage students and courses',
                  gradientColors: [Colors.green.shade400, Colors.teal.shade400],
                ),
                const SizedBox(height: 32),
                // COURSE LIST
                Text(
                  'Courses',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 18),
                Obx(
                  () => Column(
                    children: List.generate(_coursesController.courses.length, (
                      index,
                    ) {
                      final course = _coursesController.courses[index];
                      final courseProgress = _coursesController
                          .courseAvgCompletionById(course.id);
                      return _CourseDashCard(
                        course: course,
                        avgCompletion: courseProgress,
                        onTap:
                            () => Get.to(
                              () => MadrassaCourseDetailScreen(
                                courseId: course.id,
                              ),
                            ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),
                // PENDING APPROVALS
                Text(
                  'Pending Approvals',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildPendingDummyList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPendingDummyList() {
    final pendingStudents = [
      {'name': 'Muhammad Ali', 'email': 'ali@student.com'},
      {'name': 'Sara Khan', 'email': 'sara@student.com'},
    ];
    return [
      for (var student in pendingStudents)
        _PendingStudentCard(student['name']!, student['email']!),
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 38),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Just a repeated card for each course in dash
class _CourseDashCard extends StatelessWidget {
  final CourseModel course;
  final double avgCompletion;
  final VoidCallback onTap;
  const _CourseDashCard({
    required this.course,
    required this.avgCompletion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                course.imageUrl!,
                width: 70,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: avgCompletion,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(avgCompletion * 100).toStringAsFixed(1)}% completed',
                    style: TextStyle(color: Color(0xFF6366F1)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 22,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple card for approval
class _PendingStudentCard extends StatelessWidget {
  final String name;
  final String email;
  const _PendingStudentCard(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.11),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.person, color: Colors.green.shade700, size: 30),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(email, style: GoogleFonts.poppins(fontSize: 14)),
        trailing: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.teal.shade400],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'Approve',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
