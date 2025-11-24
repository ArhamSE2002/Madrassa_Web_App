import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/course_model.dart';

class CourseCreateScreen extends StatefulWidget {
  const CourseCreateScreen({Key? key}) : super(key: key);

  @override
  State<CourseCreateScreen> createState() => _CourseCreateScreenState();
}

class _CourseCreateScreenState extends State<CourseCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _imageUrlController = TextEditingController();
  CourseCategory _selectedCategory = CourseCategory.technical;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Urdu', 'Arabic'];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _teacherIdController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Course created successfully!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: const Color(0xFF6366F1),
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: Text(
      //     'Create New Course',
      //     style: GoogleFonts.inter(
      //       fontWeight: FontWeight.w700,
      //       fontSize: 20,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Basic Information'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _titleController,
                      label: 'Course Title',
                      hint: 'Enter course title',
                      icon: Icons.book_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter course title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Describe what students will learn',
                      icon: Icons.description_outlined,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter course description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Course Details'),
                    const SizedBox(height: 16),
                    _buildCategorySelector(),
                    const SizedBox(height: 16),
                    _buildLanguageSelector(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Instructor Information'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _teacherIdController,
                      label: 'Instructor ID',
                      hint: 'Enter instructor identifier',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter instructor ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Course Media'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _imageUrlController,
                      label: 'Cover Image URL',
                      hint: 'https://example.com/image.jpg',
                      icon: Icons.image_outlined,
                      helperText:
                          'Add a cover image to make your course more attractive',
                    ),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Create a New Course',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in the details below to create your course',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade900),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          helperStyle: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 22),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  color: const Color(0xFF6366F1),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'Course Category',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  CourseCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return _buildCategoryChip(category, isSelected);
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(CourseCategory category, bool isSelected) {
    IconData icon;
    Color color;

    switch (category) {
      case CourseCategory.technical:
        icon = Icons.computer;
        color = const Color(0xFFFF9800);
        break;
      case CourseCategory.vocational:
        icon = Icons.build;
        color = const Color(0xFF4CAF50);
        break;
      case CourseCategory.scientific:
        icon = Icons.science;
        color = const Color(0xFF9C27B0);
        break;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              category.toString().split('.').last.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedLanguage,
        decoration: InputDecoration(
          labelText: 'Course Language',
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
          prefixIcon: Icon(
            Icons.language,
            color: const Color(0xFF6366F1),
            size: 22,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade900),
        dropdownColor: Colors.white,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
        items:
            _languages.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(lang, style: GoogleFonts.inter(fontSize: 15)),
              );
            }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value!;
          });
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'Create Course',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
