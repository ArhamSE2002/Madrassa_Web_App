import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../controllers/course_controller.dart';
import '../../../utils/responsive.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Technical',
    'Vocational',
    'Scientific',
  ];
  late final CourseController _courseController;

  @override
  void initState() {
    super.initState();
    _courseController = Get.put(CourseController(), permanent: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_courseController.courses.isEmpty &&
          !_courseController.isLoading.value) {
        await _courseController.loadCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final availableCourses =
          _courseController.courses.where((course) {
            final matchesSearch =
                _searchQuery.isEmpty ||
                course.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                course.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
            final matchesCategory =
                _selectedCategory == 'All' ||
                course.category.toString().split('.').last.toLowerCase() ==
                    _selectedCategory.toLowerCase();
            return matchesSearch && matchesCategory;
          }).toList();
      availableCourses.forEach((course) {
        print('${course.description}');
      });

      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Explore Courses',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF0056D2),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              color: const Color(0xFF0056D2),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildCategoryFilter(),
                ],
              ),
            ),
          ),
        ),
        body:
            _courseController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : availableCourses.isEmpty
                ? _buildEmptyState()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '${availableCourses.length} courses available',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Responsive(
                        mobile: _buildCoursesList(availableCourses),
                        tablet: _buildCoursesGrid(availableCourses, 2),
                        desktop: _buildCoursesGrid(availableCourses, 3),
                      ),
                    ),
                  ],
                ),
      );
    });
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for courses...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey.shade600),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: GoogleFonts.inter(fontSize: 15),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                category,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0.2),
              selectedColor: const Color(0xFF003D99),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No courses found',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List courses) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCourseListCard(courses[index]),
        );
      },
    );
  }

  Widget _buildCoursesGrid(List courses, int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _buildCourseGridCard(courses[index]);
      },
    );
  }

  Widget _buildCourseListCard(dynamic course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child:
                  course.imageUrl != null && course.imageUrl!.isNotEmpty
                      ? Image.network(
                        course.imageUrl!,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => _buildPlaceholderImage(course),
                      )
                      : _buildPlaceholderImage(course),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category.toString().split('.').last.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0056D2),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.enrolledCount} students',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.lectures.length} lectures',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseGridCard(course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Course Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child:
                  course.imageUrl != null && course.imageUrl!.isNotEmpty
                      ? Image.network(
                        course.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => _buildPlaceholderImage(course),
                      )
                      : _buildPlaceholderImage(course),
            ),

            // 📝 Course Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📚 Title
                  Text(
                    course.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // 💬 Description
                  Text(
                    course.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // // 🔖 Category & 🌐 Language
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         const Icon(
                  //           Icons.category_outlined,
                  //           size: 14,
                  //           color: Colors.blueGrey,
                  //         ),
                  //         const SizedBox(width: 4),
                  //         // Text(
                  //         //   course.category!.toString().split('.').last.capitalize(),
                  //         //   style: GoogleFonts.inter(
                  //         //     fontSize: 12,
                  //         //     fontWeight: FontWeight.w500,
                  //         //     color: Colors.blueGrey,
                  //         //   ),
                  //         // ),
                  //       ],
                  //     ),
                  //     Row(
                  //       children: [
                  //         const Icon(
                  //           Icons.language_outlined,
                  //           size: 14,
                  //           color: Colors.teal,
                  //         ),
                  //         const SizedBox(width: 4),
                  //         Text(
                  //           course.language,
                  //           style: GoogleFonts.inter(
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.teal,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 10),

                  // 👥 Enrolled & 🎬 Lectures Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.enrolledCount} enrolled',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_circle_outline,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lectures.length} lectures',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(dynamic course) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0056D2).withOpacity(0.7),
            const Color(0xFF0056D2).withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(Icons.school_rounded, size: 60, color: Colors.white),
      ),
    );
  }
}
