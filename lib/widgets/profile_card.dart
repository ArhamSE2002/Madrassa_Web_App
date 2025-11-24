import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  final String subtitle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? badgeText;
  final bool showAvatarBanner;
  final bool showMadrassaLogo;
  final bool showStudentAvatar;

  const ProfileCard({
    Key? key,
    required this.user,
    required this.subtitle,
    this.onEdit,
    this.onDelete,
    this.badgeText,
    this.showAvatarBanner = false,
    this.showMadrassaLogo = false,
    this.showStudentAvatar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (showAvatarBanner)
                  Positioned(
                    top: -11,
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.withOpacity(.3),
                            Colors.deepPurpleAccent.withOpacity(.13),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                if (showMadrassaLogo)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green[50],
                    child: Icon(Icons.apartment, color: Colors.green, size: 34),
                  )
                else if (showStudentAvatar)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[50],
                    child: Icon(
                      Icons.school,
                      color: Colors.lightBlue,
                      size: 34,
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.purple.shade50,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[700],
                      ),
                    ),
                  ),
                if (badgeText != null)
                  Positioned(
                    bottom: -8,
                    child: AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _roleColor(user.role).withOpacity(.79),
                          boxShadow: [
                            BoxShadow(
                              color: _roleColor(user.role).withOpacity(.12),
                              blurRadius: 7,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _roleIcon(user.role),
                              size: 17,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              badgeText!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                ],
              ),
            ),
            if (onEdit != null || onDelete != null)
              Row(
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: onEdit,
                      color: Colors.indigo,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_forever_rounded),
                      color: Colors.red,
                      onPressed: onDelete,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.amber;
      case UserRole.teacher:
        return Colors.deepPurple;
      case UserRole.madrassa:
        return Colors.green;
      case UserRole.student:
      default:
        return Colors.blue;
    }
  }

  IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.star_rounded;
      case UserRole.teacher:
        return Icons.person_4_rounded;
      case UserRole.madrassa:
        return Icons.apartment_rounded;
      case UserRole.student:
      default:
        return Icons.school_rounded;
    }
  }
}
