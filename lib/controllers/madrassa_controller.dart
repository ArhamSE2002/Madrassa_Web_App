import 'package:get/get.dart';
import 'package:madressa_learning_platform/models/course_model.dart';
import 'package:madressa_learning_platform/models/lecture_model.dart';
import 'package:madressa_learning_platform/models/student_course_progess.dart';
import 'package:madressa_learning_platform/models/student_model.dart';

// Controller handles all state for course selection and student progress
class MadrassaCoursesController extends GetxController {
  var courses = <CourseModel>[].obs;
  var selectedCourse = Rxn<CourseModel>();
  var students = <StudentModel>[].obs;
  var studentProgresses = <StudentCourseProgress>[].obs;
  var isLoading = false.obs;

  // Call this to set up initial demo/test data
  void loadDemoData() {
    // For demo, create some students, a few courses, and progress values
    students.value = [
      StudentModel(
        id: 's1',
        name: 'Ahmed Ali',
        imageUrl:
            'https://thumbs.dreamstime.com/b/portrait-handsome-smiling-young-man-folded-arms-smiling-joyful-cheerful-men-crossed-hands-isolated-studio-shot-172869765.jpg',
      ),
      StudentModel(
        id: 's2',
        name: 'Fatima Noor',
        imageUrl:
            'https://thumbs.dreamstime.com/b/portrait-handsome-smiling-young-man-folded-arms-smiling-joyful-cheerful-men-crossed-hands-isolated-studio-shot-172869765.jpg',
      ),
      StudentModel(id: 's3', name: 'Bilal Khan', imageUrl: ""),
      StudentModel(
        id: 's4',
        name: 'Sara Rizvi',
        imageUrl:
            'https://thumbs.dreamstime.com/b/portrait-handsome-smiling-young-man-folded-arms-smiling-joyful-cheerful-men-crossed-hands-isolated-studio-shot-172869765.jpg',
      ),
    ];

    final course1 = CourseModel(
      id: 'c1',
      title: 'Quran with Tajweed',
      description: 'Learn Quran recitation with Tajweed rules.',
      imageUrl:
          'https://images.pexels.com/photos/2387873/pexels-photo-2387873.jpeg',
      category: CourseCategory.technical,
      teacherId: 'Teacher1',
      language: 'Urdu',
      lectures: [
        LectureModel(
          id: 'l1',
          title: 'Introduction',
          order: 1,
          type: LectureType.video,
          resourceUrl: 'video-url-1',
        ),
        LectureModel(
          id: 'l2',
          title: 'Makhaarij',
          order: 2,
          type: LectureType.pdf,
          resourceUrl: 'pdf-url-1',
        ),
        // Add more lectures...
      ],
      createdAt: DateTime.now(),
    );
    final course2 = CourseModel(
      id: 'c2',
      createdAt: DateTime.now(),
      title: 'Fiqh Basics',
      description: 'Fundamental rules of Islamic Fiqh.',
      imageUrl:
          'https://images.pexels.com/photos/256401/pexels-photo-256401.jpeg',
      category: CourseCategory.scientific,
      teacherId: 'Teacher2',
      language: 'Urdu',
      lectures: [
        LectureModel(
          id: 'l1',
          title: 'Fiqh Intro',
          order: 1,
          type: LectureType.video,
          resourceUrl: 'video-url',
        ),
      ],
    );
    courses.value = [course1, course2];

    studentProgresses.value = [
      StudentCourseProgress(studentId: 's1', courseId: 'c1', completion: 0.81),
      StudentCourseProgress(studentId: 's2', courseId: 'c1', completion: 0.45),
      StudentCourseProgress(studentId: 's3', courseId: 'c1', completion: 0.72),
      StudentCourseProgress(studentId: 's4', courseId: 'c1', completion: 0.12),
      StudentCourseProgress(studentId: 's1', courseId: 'c2', completion: 0.50),
      StudentCourseProgress(studentId: 's2', courseId: 'c2', completion: 0.85),
      StudentCourseProgress(studentId: 's3', courseId: 'c2', completion: 0.71),
      StudentCourseProgress(studentId: 's4', courseId: 'c2', completion: 0.23),
    ];
  }

  void selectCourse(CourseModel course) async {
    selectedCourse.value = course;
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
  }

  // For specific course...
  double courseAvgCompletionById(String id) {
    final progresses =
        studentProgresses.where((p) => p.courseId == id).toList();
    if (progresses.isEmpty) return 0.0;
    return progresses.map((p) => p.completion).reduce((a, b) => a + b) /
        progresses.length;
  }

  List<Map<String, dynamic>> currentStudentProgressByCourseId(String id) {
    return students.map((stu) {
      final prog = studentProgresses.firstWhereOrNull(
        (p) => p.courseId == id && p.studentId == stu.id,
      );
      return {'student': stu, 'completion': prog?.completion ?? 0.0};
    }).toList();
  }

  // Get student progress list for selected course
  List<Map<String, dynamic>> get currentStudentProgress {
    if (selectedCourse.value == null) return [];
    final cId = selectedCourse.value!.id;
    return students.map((stu) {
      final prog = studentProgresses.firstWhereOrNull(
        (p) => p.courseId == cId && p.studentId == stu.id,
      );
      return {'student': stu, 'completion': prog?.completion ?? 0.0};
    }).toList();
  }

  // Calculate course avg completion for progress bar
  double get courseAvgCompletion {
    if (selectedCourse.value == null) return 0.0;
    final cId = selectedCourse.value!.id;
    final progresses =
        studentProgresses.where((p) => p.courseId == cId).toList();
    if (progresses.isEmpty) return 0.0;
    return progresses.map((p) => p.completion).reduce((a, b) => a + b) /
        progresses.length;
  }
}
