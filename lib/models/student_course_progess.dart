class StudentCourseProgress {
  final String studentId;
  final String courseId;
  final double completion; // 0-1 (e.g., 0.84 for 84%)

  StudentCourseProgress({
    required this.studentId,
    required this.courseId,
    required this.completion,
  });
}
