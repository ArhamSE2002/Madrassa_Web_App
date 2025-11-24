import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madressa_learning_platform/models/lecture_model.dart';
import 'package:get/get.dart';
import '../../../models/course_model.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/course_controller.dart';
import '../../../utils/responsive.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Responsive(
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseHeader(context),
              const SizedBox(height: 24),
              _buildQuickStats(context),
              const SizedBox(height: 32),
              _buildAboutSection(context),
              const SizedBox(height: 32),
              _buildSkillsSection(context),
              const SizedBox(height: 32),
              _buildCurriculumSection(context),
              const SizedBox(height: 32),
              _buildInstructorSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCourseHeader(context),
                          const SizedBox(height: 32),
                          _buildAboutSection(context),
                          const SizedBox(height: 32),
                          _buildSkillsSection(context),
                          const SizedBox(height: 32),
                          _buildCurriculumSection(context),
                          const SizedBox(height: 32),
                          _buildInstructorSection(context),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: _buildStickyEnrollCard(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0056D2),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            course.imageUrl != null && course.imageUrl!.isNotEmpty
                ? Image.network(
                    course.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildGradientBackground(),
                  )
                : _buildGradientBackground(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0056D2),
            const Color(0xFF003D99),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          _getCategoryIcon(),
          size: 100,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getCategoryColor(), width: 1.5),
            ),
            child: Text(
              course.category.toString().split('.').last.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _getCategoryColor(),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            course.title,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            course.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final totalDuration = _calculateTotalDuration();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.signal_cellular_alt,
            'Beginner',
            'Level',
          ),
          _buildDivider(),
          _buildStatItem(
            Icons.schedule_outlined,
            totalDuration,
            'Duration',
          ),
          _buildDivider(),
          _buildStatItem(
            Icons.play_circle_outline,
            '${course.lectures.length}',
            'Lectures',
          ),
          _buildDivider(),
          _buildStatItem(
            Icons.people_outline,
            '${course.enrolledCount}',
            'Enrolled',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: const Color(0xFF0056D2)),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this course',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: const Color(0xFF0056D2), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Course Information',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.language, 'Language', course.language),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person_outline, 'Instructor', course.teacherId),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.category_outlined, 'Category', 
                  course.category.toString().split('.').last),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you\'ll learn',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD6E4FF)),
            ),
            child: Column(
              children: course.lectures.take(6).map((lecture) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0056D2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          lecture.title,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course curriculum',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                '${course.lectures.length} lectures',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0056D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...course.lectures.asMap().entries.map((entry) {
            final index = entry.key;
            final lecture = entry.value;
            return _buildLectureItem(lecture, index + 1);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLectureItem(dynamic lecture, int index) {
    IconData icon;
    Color color;
    String type;

    switch (lecture.type) {
      case LectureType.video:
        icon = Icons.play_circle_filled;
        color = const Color(0xFFE53935);
        type = 'Video';
        break;
      case LectureType.pdf:
        icon = Icons.picture_as_pdf;
        color = const Color(0xFFFF5722);
        type = 'PDF';
        break;
      case LectureType.image:
        icon = Icons.image;
        color = const Color(0xFF4CAF50);
        type = 'Image';
        break;
      case LectureType.doc:
        icon = Icons.description;
        color = const Color(0xFF2196F3);
        type = 'Document';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.person, color: Colors.black, size: 24),
          ),
        ),
        title: Text(
          lecture.title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Lecture $index • ',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        trailing: Icon(
          Icons.lock_outline,
          color: Colors.grey.shade400,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildInstructorSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your instructor',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF0056D2),
                  child: Text(
                    course.teacherId.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.teacherId,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Course Instructor',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyEnrollCard(BuildContext context) {
    final authController = Get.put(AuthController(), permanent: true);
    final courseController = Get.put(CourseController(), permanent: true);
    final user = authController.currentUser.value;
    if (user == null) return const SizedBox();

    return Obx(() {
      final isEnrolled = courseController.enrollments.any(
        (e) => e.courseId == course.id && e.studentId == user.id,
      );
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ready to start learning?',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEnrolled
                  ? null
                  : () async {
                      await courseController.enrollInCourse(user.id, course.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Successfully enrolled in ${course.title}!',
                            style: GoogleFonts.inter(),
                          ),
                          backgroundColor: const Color(0xFF4CAF50),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnrolled ? Colors.grey : const Color(0xFF0056D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isEnrolled ? 'Already Enrolled' : 'Enroll Now',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This course includes:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 12),
            _buildIncludeItem(Icons.ondemand_video, '${course.lectures.length} lectures'),
            _buildIncludeItem(Icons.file_download_outlined, 'Downloadable resources'),
            _buildIncludeItem(Icons.all_inclusive, 'Full lifetime access'),
            _buildIncludeItem(Icons.phone_android, 'Access on mobile'),
          ],
        ),
      );
    });
  }

  Widget _buildIncludeItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTotalDuration() {
    // Placeholder logic - customize based on your needs
    final hours = (course.lectures.length * 0.5).ceil();
    return '$hours hours';
  }

  Color _getCategoryColor() {
    switch (course.category) {
      case CourseCategory.technical:
        return const Color(0xFFFF9800);
      case CourseCategory.vocational:
        return const Color(0xFF4CAF50);
      case CourseCategory.scientific:
        return const Color(0xFF9C27B0);
    }
  }

  IconData _getCategoryIcon() {
    switch (course.category) {
      case CourseCategory.technical:
        return Icons.computer;
      case CourseCategory.vocational:
        return Icons.build;
      case CourseCategory.scientific:
        return Icons.science;
    }
  }
}
