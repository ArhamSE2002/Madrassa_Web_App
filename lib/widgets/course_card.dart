import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? heroImage;
  final bool showStats;

  const CourseCard({
    Key? key,
    required this.course,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.heroImage,
    this.showStats = false,
  }) : super(key: key);

  Color _getCategoryColor() {
    switch (course.category) {
      case CourseCategory.technical:
        return Colors.orange;
      case CourseCategory.vocational:
        return Colors.green;
      case CourseCategory.scientific:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon() {
    switch (course.category) {
      case CourseCategory.technical:
        return Icons.computer;
      case CourseCategory.vocational:
        return Icons.build;
      case CourseCategory.scientific:
        return Icons.science;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = heroImage ?? course.imageUrl;
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child:
                  imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                        imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getCategoryColor().withOpacity(.14),
                              _getCategoryColor().withOpacity(.07),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(),
                            size: 58,
                            color: _getCategoryColor().withOpacity(0.65),
                          ),
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: const TextStyle(color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          course.category.toString().split('.').last,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: _getCategoryColor().withOpacity(0.2),
                        labelStyle: TextStyle(color: _getCategoryColor()),
                      ),
                      if (showStats)
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 18,
                              color: Colors.blueGrey.shade400,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${course.enrolledCount}',
                              style: TextStyle(
                                color: Colors.blueGrey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(Icons.person, size: 15, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          course.teacherId,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: onEdit,
                          color: Colors.indigo,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_forever),
                          color: Colors.red,
                          onPressed: onDelete,
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
}
