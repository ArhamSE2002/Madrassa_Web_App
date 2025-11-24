import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../models/course_model.dart';
import '../../models/enrollment_model.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/course_card.dart';
import '../../utils/responsive.dart';
import '../course/views/course_detail_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final UserModel student;

  const StudentDetailScreen({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put(CourseController(), permanent: true);
    if (courseController.courses.isEmpty && !courseController.isLoading.value) {
      courseController.loadCourses();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Obx(() {
        final enrollments = courseController.enrollments
            .where((e) => e.studentId == student.id)
            .toList();
        final enrolledCourses = courseController.getEnrolledCourses(student.id);
        final completedCourses = enrollments.where((e) => e.progress >= 100).length;
        final avgProgress = enrollments.isEmpty
            ? 0.0
            : enrollments.map((e) => e.progress).reduce((a, b) => a + b) /
                enrollments.length;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.cyan.shade50,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 32),
                _buildStatsRow(
                  context,
                  enrolledCourses.length,
                  completedCourses,
                  avgProgress,
                ),
                const SizedBox(height: 32),
                _buildInfoSection(context),
                const SizedBox(height: 32),
                _buildProgressSection(context, enrollments),
                const SizedBox(height: 32),
                _buildCoursesSection(context, enrolledCourses),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Colors.cyan.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              student.name[0].toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade400,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'STUDENT',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    int enrolledCourses,
    int completedCourses,
    double avgProgress,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Enrolled',
            enrolledCourses.toString(),
            Icons.book_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Completed',
            completedCourses.toString(),
            Icons.check_circle_rounded,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Avg Progress',
            '${avgProgress.toStringAsFixed(0)}%',
            Icons.trending_up_rounded,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Information',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.email, 'Email', student.email),
            const Divider(),
            if (student.madrassaName != null) ...[
              _buildInfoRow(
                Icons.school,
                'Madrassa',
                student.madrassaName!,
              ),
              const Divider(),
            ],
            _buildInfoRow(
              Icons.calendar_today,
              'Member Since',
              '${student.createdAt.day}/${student.createdAt.month}/${student.createdAt.year}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade400, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    List<EnrollmentModel> enrollments,
  ) {
    if (enrollments.isEmpty) {
      return const SizedBox();
    }

    final courseController = Get.find<CourseController>();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Progress',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...enrollments.map((enrollment) {
              final course = courseController.courses.firstWhere((c) => c.id == enrollment.courseId);
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${enrollment.progress.toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: enrollment.progress / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade400,
                        ),
                      ),
                    ),
                    if (enrollment.certificateIssued) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Certificate Issued',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesSection(
    BuildContext context,
    List<CourseModel> courses,
  ) {
    if (courses.isEmpty) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No enrolled courses yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enrolled Courses',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        Responsive(
          mobile: _buildCoursesList(courses),
          tablet: _buildCoursesGrid(context, courses, 2),
          desktop: _buildCoursesGrid(context, courses, 3),
        ),
      ],
    );
  }

  Widget _buildCoursesList(List<CourseModel> courses) {
    return Column(
      children: courses.map((course) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CourseCard(
            course: course,
            heroImage: course.imageUrl,
            showStats: true,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCoursesGrid(
    BuildContext context,
    List<CourseModel> courses,
    int crossAxisCount,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseDetailScreen(course: courses[index]),
              ),
            );
          },
          child: CourseCard(
            course: courses[index],
            heroImage: courses[index].imageUrl,
            showStats: true,
          ),
        );
      },
    );
  }
}

