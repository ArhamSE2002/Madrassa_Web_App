import '../models/course_model.dart';
import '../models/lecture_model.dart';

final List<CourseModel> mockCourses = [
  CourseModel(
    id: '1',
    title: 'Basic Computer Skills',
    description: 'Learn fundamental computer operations and MS Office',
    category: CourseCategory.technical,
    teacherId: 'teacher-1',
    language: 'Urdu',
    imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4',
    lectures: [
      LectureModel(
        id: 'L1',
        title: 'Introduction to Computers',
        type: LectureType.video,
        resourceUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        order: 1,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    enrolledCount: 45,
  ),
  CourseModel(
    id: '2',
    title: 'Electrical Wiring Basics',
    description: 'Introduction to electrical wiring and safety',
    category: CourseCategory.vocational,
    teacherId: 'teacher-1',
    language: 'Urdu',
    imageUrl: 'https://images.unsplash.com/photo-1558002038-1055907df827',
    lectures: [
      LectureModel(
        id: 'L2',
        title: 'Safety First',
        type: LectureType.pdf,
        resourceUrl: 'https://example.com/pdf1',
        order: 1,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    enrolledCount: 32,
  ),
  CourseModel(
    id: '3',
    title: 'Mathematics Fundamentals',
    description: 'Basic mathematics for everyday applications',
    category: CourseCategory.scientific,
    teacherId: 'teacher-3',
    language: 'English',
    imageUrl: 'https://images.unsplash.com/photo-1529078155058-5d716f45d604',
    lectures: [
      LectureModel(
        id: 'L3',
        title: 'Numbers and Operations',
        type: LectureType.doc,
        resourceUrl: 'https://example.com/doc1',
        order: 1,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    enrolledCount: 67,
  ),
];
