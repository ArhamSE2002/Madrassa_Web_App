import 'package:madressa_learning_platform/models/lecture_model.dart';

enum CourseCategory { scientific, technical, vocational }

class CourseModel {
  final String id, title, description, teacherId, language;
  final CourseCategory category;
  final List<LectureModel> lectures;
  final DateTime createdAt;
  final int enrolledCount;
  final String? imageUrl;
  CourseModel({
    this.imageUrl,
    required this.id, required this.title, required this.description,
    required this.category, required this.teacherId,
    this.language = "English", this.lectures = const [],
    required this.createdAt, this.enrolledCount = 0,
  });
 // ... Add factory/fromJson/toJson as above, updating lectures accordingly
}
