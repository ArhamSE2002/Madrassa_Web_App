// lib/models/enrollment_model.dart
class EnrollmentModel {
  final String id;
  final String studentId;
  final String courseId;
  final double progress;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final bool certificateIssued;

  EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.progress = 0.0,
    required this.enrolledAt,
    this.completedAt,
    this.certificateIssued = false,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
      progress: json['progress'].toDouble(),
      enrolledAt: DateTime.parse(json['enrolledAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      certificateIssued: json['certificateIssued'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'progress': progress,
      'enrolledAt': enrolledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'certificateIssued': certificateIssued,
    };
  }
}
