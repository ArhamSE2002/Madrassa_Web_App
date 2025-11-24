import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madressa_learning_platform/controllers/madrassa_controller.dart';

class MadrassaCourseDetailScreen extends StatelessWidget {
  final String courseId;

  MadrassaCourseDetailScreen({required this.courseId});

  final MadrassaCoursesController _controller = Get.put(
    MadrassaCoursesController(),
  );

  @override
  Widget build(BuildContext context) {
    final course = _controller.courses.firstWhere((c) => c.id == courseId);
    final studentProgressList = _controller.currentStudentProgressByCourseId(
      courseId,
    );
    final avgCompletion = _controller.courseAvgCompletionById(courseId);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.green.shade400,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Summary Top Card
            Material(
              borderRadius: BorderRadius.circular(18),
              elevation: 2,
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(18),
                width: double.infinity,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        course.imageUrl!,
                        width: 90,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            course.description,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: avgCompletion,
                              minHeight: 9,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF6366F1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${(avgCompletion * 100).toStringAsFixed(1)}% overall completed',
                            style: TextStyle(color: Color(0xFF6366F1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Students Progress',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            ...studentProgressList.map((sp) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (sp["student"].imageUrl == null)
                      CircleAvatar(child: Icon(Icons.person), radius: 26),
                    if (sp["student"].imageUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(sp['student'].imageUrl),
                        radius: 26,
                      ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sp['student'].name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 7),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: sp['completion'],
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(sp['completion'] * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
