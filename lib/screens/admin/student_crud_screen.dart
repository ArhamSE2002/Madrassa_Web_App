import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_card.dart';
import '../../controllers/auth_controller.dart';
import '../admin/user_detail_screen.dart';
import '../../data/mock_students.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({Key? key}) : super(key: key);

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen>
    with SingleTickerProviderStateMixin {
  List<UserModel> students = [];
  String search = "";
  late AnimationController _animController;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController(), permanent: true);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..forward();
    students = List<UserModel>.from(mockStudents);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addStudent() {
    setState(() {
      students.add(
        UserModel(
          id: 'S${students.length + 1}',
          name: 'New Student',
          email: 'student${students.length + 1}@mail.com',
          role: UserRole.student,
          madrassaName: 'Jamia Islamia',
          createdAt: DateTime.now(),
        ),
      );
      _animController.reset();
      _animController.forward();
    });
  }

  void _deleteStudent(UserModel user) => setState(() => students.remove(user));
  @override
  Widget build(BuildContext context) {
    final filtered = students.where((s) =>
      s.name.toLowerCase().contains(search.toLowerCase()) ||
      s.email.toLowerCase().contains(search.toLowerCase()) ||
      (s.madrassaName?.toLowerCase().contains(search.toLowerCase()) ?? false)
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.lightBlue.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      backgroundColor: Colors.blue.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        child: const Icon(Icons.add),
        elevation: 15,
        onPressed: _addStudent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(19),
            child: Material(
              elevation: 8,
              shadowColor: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search Student...",
                  hintStyle: GoogleFonts.poppins(color: Colors.blue.shade200),
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
              builder: (context, _) => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, idx) {
                  return AnimatedOpacity(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 600),
                    opacity: (idx + 1).toDouble() <=
                            _animController.value * filtered.length
                        ? 1
                        : 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailScreen(user: filtered[idx]),
                          ),
                        );
                      },
                      child: ProfileCard(
                        user: filtered[idx],
                        subtitle: filtered[idx].madrassaName ?? '',
                        onEdit: () {},
                        onDelete: () => _deleteStudent(filtered[idx]),
                        badgeText: 'Student',
                        showStudentAvatar: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
