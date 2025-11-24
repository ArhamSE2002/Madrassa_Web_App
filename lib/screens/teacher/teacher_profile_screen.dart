import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../models/course_model.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/course_card.dart';
import '../../utils/responsive.dart';
import '../course/views/course_detail_screen.dart';

class TeacherDetailScreen extends StatelessWidget {
  final UserModel teacher;

  const TeacherDetailScreen({Key? key, required this.teacher})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put(CourseController(), permanent: true);
    if (courseController.courses.isEmpty && !courseController.isLoading.value) {
      courseController.loadCourses();
    }
    final teacherCourses =
        courseController.courses
            .where((c) => c.teacherId == teacher.id)
            .toList();
    final totalStudents = teacherCourses.fold<int>(
      0,
      (sum, course) => sum + course.enrolledCount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teacher Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          final teacherCoursesObs =
              courseController.courses
                  .where((c) => c.teacherId == teacher.id)
                  .toList();
          final totalStudentsObs = teacherCoursesObs.fold<int>(
            0,
            (sum, c) => sum + c.enrolledCount,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 32),
                _buildStatsRow(
                  context,
                  totalStudentsObs,
                  teacherCoursesObs.length,
                ),
                const SizedBox(height: 32),
                _buildInfoSection(context),
                const SizedBox(height: 32),
                _buildCoursesSection(context, teacherCoursesObs),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.indigo.shade400],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, size: 50, color: Colors.white),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.name,
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
                    'TEACHER',
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
    int totalStudents,
    int totalCourses,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Courses',
            totalCourses.toString(),
            Icons.book_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Total Students',
            totalStudents.toString(),
            Icons.people_rounded,
            Colors.green,
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
      padding: const EdgeInsets.all(24),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
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
              'Teacher Information',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.email, 'Email', teacher.email),
            const Divider(),
            if (teacher.madrassaName != null) ...[
              _buildInfoRow(Icons.school, 'Madrassa', teacher.madrassaName!),
              const Divider(),
            ],
            _buildInfoRow(
              Icons.calendar_today,
              'Member Since',
              '${teacher.createdAt.day}/${teacher.createdAt.month}/${teacher.createdAt.year}',
            ),
            const Divider(),
            _buildInfoRow(
              Icons.workspace_premium,
              'Qualifications',
              'Masters in Education\nCertified Teacher',
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
          Icon(icon, color: Colors.deepPurple.shade400, size: 24),
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

  Widget _buildCoursesSection(BuildContext context, List<CourseModel> courses) {
    if (courses.isEmpty) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  'No courses created yet',
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
          'Created Courses',
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
      children:
          courses.map((course) {
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
