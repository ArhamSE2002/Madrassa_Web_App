import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/course_model.dart';
import '../../../models/lecture_model.dart';

class CourseContentAddScreen extends StatefulWidget {
  final CourseModel course;

  const CourseContentAddScreen({Key? key, required this.course})
      : super(key: key);

  @override
  State<CourseContentAddScreen> createState() => _CourseContentAddScreenState();
}

class _CourseContentAddScreenState extends State<CourseContentAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  LectureType _selectedType = LectureType.video;
  int _order = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
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
                'Lecture added successfully!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      _titleController.clear();
      _urlController.clear();
      setState(() {
        _order++;
      });
    }
  }

  // --- MAIN BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6366F1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Content',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              widget.course.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header (purely decoration, doesn't require Material) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1),
                    const Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_box,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Lecture',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lecture $_order',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---- FORM ----
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionTitle(title: 'Lecture Information'),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: _CustomTextField(
                        controller: _titleController,
                        label: 'Lecture Title',
                        hint: 'Enter lecture title',
                        icon: Icons.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter lecture title';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    _SectionTitle(title: 'Content Type'),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: Container(
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
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select content type',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: LectureType.values.map((type) {
                                final isSelected = _selectedType == type;
                                IconData icon;
                                Color color;
                                String label;

                                switch (type) {
                                  case LectureType.video:
                                    icon = Icons.play_circle_filled;
                                    color = const Color(0xFFE53935);
                                    label = 'Video';
                                    break;
                                  case LectureType.pdf:
                                    icon = Icons.picture_as_pdf;
                                    color = const Color(0xFFFF5722);
                                    label = 'PDF';
                                    break;
                                  case LectureType.image:
                                    icon = Icons.image;
                                    color = const Color(0xFF4CAF50);
                                    label = 'Image';
                                    break;
                                  case LectureType.doc:
                                    icon = Icons.description;
                                    color = const Color(0xFF2196F3);
                                    label = 'Document';
                                    break;
                                }

                                return Material(
                                  color: Colors.transparent,
                                  child: _ContentTypeChip(
                                    icon: icon,
                                    label: label,
                                    color: color,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        _selectedType = type;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    _SectionTitle(title: 'Resource Details'),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: _CustomTextField(
                        controller: _urlController,
                        label: 'Resource URL',
                        hint: 'https://example.com/resource',
                        icon: Icons.link,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter resource URL';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Material(
                      color: Colors.transparent,
                      child: _CustomTextField(
                        initialValue: _order.toString(),
                        label: 'Lecture Order',
                        hint: 'Position in course',
                        icon: Icons.format_list_numbered,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _order = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Submit Button wrapped in Material for splash/ripple
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                            ],
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
                          child: _isLoading
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
                                    const Icon(Icons.add, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Add Lecture',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
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
}

// --- REUSABLE WIDGETS ---
// Section title
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
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
}

// Fully protected custom text field
class _CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  const _CustomTextField({
    this.controller,
    this.initialValue,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // Always inside Material wrapper!
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: Colors.grey.shade900,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
    );
  }
}

// Content type chip now always wrapped in Material in parent
class _ContentTypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContentTypeChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
