import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/course_model.dart';
import '../../widgets/course_card.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/responsive.dart';
import '../course/views/course_detail_screen.dart';

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({Key? key}) : super(key: key);
  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen>
    with SingleTickerProviderStateMixin {
  List<CourseModel> courses = [];
  String search = "";
  late AnimationController _animController;
  late final AuthController _authController;
  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController(), permanent: true);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    courses = [
      CourseModel(
        id: 'c1',
        title: 'Mathematics Fundamentals',
        description:
            'Learn basic mathematics for everyday applications and problem solving',
        category: CourseCategory.scientific,
        teacherId: 'Dr. Khalid Hassan',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        enrolledCount: 45,
        lectures: [],
        language: 'English',
        imageUrl:
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb',
      ),
      CourseModel(
        id: 'c2',
        title: 'Computer Basics',
        description:
            'Introduction to computers, operating systems, and basic software usage',
        category: CourseCategory.technical,
        teacherId: 'Ms. Farah Ahmad',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        enrolledCount: 38,
        lectures: [],
        language: 'Urdu',
        imageUrl:
            'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
      ),
      CourseModel(
        id: 'c3',
        title: 'Electrical Wiring Basics',
        description:
            'Introduction to electrical wiring, safety protocols, and practical applications',
        category: CourseCategory.vocational,
        teacherId: 'Eng. Faheem Ahmad',
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
        enrolledCount: 32,
        lectures: [],
        language: 'Urdu',
        imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
      ),
      CourseModel(
        id: 'c4',
        title: 'Web Development Essentials',
        description:
            'Learn HTML, CSS, and JavaScript for building modern websites',
        category: CourseCategory.technical,
        teacherId: 'Dr. Sarah Khan',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        enrolledCount: 28,
        lectures: [],
        language: 'English',
        imageUrl:
            'https://images.unsplash.com/photo-1461749280684-dccba630e2f6',
      ),
      CourseModel(
        id: 'c5',
        title: 'Biology Basics',
        description: 'Introduction to biology, cells, and living organisms',
        category: CourseCategory.scientific,
        teacherId: 'Prof. Asim Raza',
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        enrolledCount: 42,
        lectures: [],
        language: 'Urdu',
        imageUrl:
            'https://images.unsplash.com/photo-1532619675605-1ede6c9ed5d4',
      ),
      CourseModel(
        id: 'c6',
        title: 'Plumbing Fundamentals',
        description: 'Learn plumbing techniques and water system maintenance',
        category: CourseCategory.vocational,
        teacherId: 'Mr. Zain Ali',
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        enrolledCount: 25,
        lectures: [],
        language: 'Urdu',
        imageUrl:
            'https://images.unsplash.com/photo-1581092160562-40aa08e78837',
      ),
      CourseModel(
        id: 'c7',
        title: 'Chemistry Introduction',
        description: 'Basic chemistry concepts, elements, and compounds',
        category: CourseCategory.scientific,
        teacherId: 'Dr. Usman Sheikh',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        enrolledCount: 35,
        lectures: [],
        language: 'English',
        imageUrl:
            'https://images.unsplash.com/photo-1532094349884-543bc11b234d',
      ),
      CourseModel(
        id: 'c8',
        title: 'Mobile App Development',
        description:
            'Build mobile applications using modern frameworks and tools',
        category: CourseCategory.technical,
        teacherId: 'Ms. Amina Malik',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        enrolledCount: 22,
        lectures: [],
        language: 'English',
        imageUrl:
            'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c',
      ),
      CourseModel(
        id: 'c9',
        title: 'Carpentry Skills',
        description: 'Master woodworking and furniture making techniques',
        category: CourseCategory.vocational,
        teacherId: 'Eng. Faheem Ahmad',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        enrolledCount: 19,
        lectures: [],
        language: 'Urdu',
        imageUrl:
            'https://images.unsplash.com/photo-1504148455328-c376907d081c',
      ),
      CourseModel(
        id: 'c10',
        title: 'Physics Principles',
        description:
            'Understanding fundamental physics laws and their applications',
        category: CourseCategory.scientific,
        teacherId: 'Dr. Khalid Hassan',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        enrolledCount: 40,
        lectures: [],
        language: 'English',
        imageUrl:
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb',
      ),
    ];
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addCourse() {
    setState(() {
      courses.add(
        CourseModel(
          id: 'c${courses.length + 1}',
          title: 'New Course',
          description: 'Some Description',
          category: CourseCategory.technical,
          teacherId: 'Teacher',
          createdAt: DateTime.now(),
          enrolledCount: 0,
          lectures: [],
          language: 'English',
          imageUrl: 'https://source.unsplash.com/1280x720/?education',
        ),
      );
      _animController.reset();
      _animController.forward();
    });
  }

  void _deleteCourse(CourseModel course) =>
      setState(() => courses.remove(course));
  @override
  Widget build(BuildContext context) {
    final filtered = courses.where((c) =>
      c.title.toLowerCase().contains(search.toLowerCase()) ||
      c.description.toLowerCase().contains(search.toLowerCase()) ||
      c.teacherId.toLowerCase().contains(search.toLowerCase())
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      backgroundColor: Colors.indigo.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade400,
        child: const Icon(Icons.add),
        elevation: 14,
        onPressed: _addCourse,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Material(
              elevation: 8,
              shadowColor: Colors.indigoAccent.shade100,
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search Course...",
                  hintStyle: GoogleFonts.poppins(color: Colors.indigo.shade200),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => setState(() => search = val),
              ),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return Responsive(
                  mobile: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeIn,
                        opacity: (idx + 1).toDouble() <=
                                _animController.value * filtered.length
                            ? 1
                            : 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  course: filtered[idx],
                                ),
                              ),
                            );
                          },
                          child: CourseCard(
                            course: filtered[idx],
                            onEdit: () {},
                            onDelete: () => _deleteCourse(filtered[idx]),
                            heroImage: filtered[idx].imageUrl ?? '',
                            showStats: true,
                          ),
                        ),
                      );
                    },
                  ),
                  desktop: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeIn,
                        opacity: (idx + 1).toDouble() <=
                                _animController.value * filtered.length
                            ? 1
                            : 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  course: filtered[idx],
                                ),
                              ),
                            );
                          },
                          child: CourseCard(
                            course: filtered[idx],
                            onEdit: () {},
                            onDelete: () => _deleteCourse(filtered[idx]),
                            heroImage: filtered[idx].imageUrl ?? '',
                            showStats: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
