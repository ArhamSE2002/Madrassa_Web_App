import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_card.dart';
import '../../controllers/auth_controller.dart';
import '../admin/user_detail_screen.dart';
import '../../data/mock_teachers.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({Key? key}) : super(key: key);

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen>
    with SingleTickerProviderStateMixin {
  List<UserModel> teachers = [];
  String search = "";
  late AnimationController _listAnimationController;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController(), permanent: true);
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    teachers = List<UserModel>.from(mockTeachers);
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  void _addTeacher() {
    setState(() {
      teachers.add(
        UserModel(
          id: 'T${teachers.length + 1}',
          name: 'New Teacher',
          email: 'teacher${teachers.length + 1}@edu.com',
          role: UserRole.teacher,
          madrassaName: 'New Madrassa',
          createdAt: DateTime.now(),
        ),
      );
      _listAnimationController.reset();
      _listAnimationController.forward();
    });
  }

  void _deleteTeacher(UserModel user) => setState(() => teachers.remove(user));

  @override
  Widget build(BuildContext context) {
    final filtered = teachers.where((t) =>
      t.name.toLowerCase().contains(search.toLowerCase()) ||
      t.email.toLowerCase().contains(search.toLowerCase()) ||
      (t.madrassaName?.toLowerCase().contains(search.toLowerCase()) ?? false)
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teachers',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade400,
        child: const Icon(Icons.add),
        onPressed: _addTeacher,
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              elevation: 8,
              shadowColor: Colors.deepPurple.shade200,
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search Teacher...",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.deepPurple.shade200,
                  ),
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
              animation: _listAnimationController,
              builder: (context, _) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final animationPercent =
                        (_listAnimationController.value * filtered.length)
                            .clamp(0, filtered.length);
                    return AnimatedOpacity(
                      curve: Curves.easeOutCubic,
                      opacity: index < animationPercent ? 1 : 0,
                      duration: const Duration(milliseconds: 1000),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserDetailScreen(user: filtered[index]),
                            ),
                          );
                        },
                        child: ProfileCard(
                          user: filtered[index],
                          subtitle: filtered[index].madrassaName ?? "",
                          onEdit: () {},
                          onDelete: () => _deleteTeacher(filtered[index]),
                          showAvatarBanner: true,
                          badgeText: 'Teacher',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
