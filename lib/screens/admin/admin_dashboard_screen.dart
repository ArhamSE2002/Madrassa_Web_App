import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:madressa_learning_platform/screens/admin/course_crud_screen.dart';
import 'package:madressa_learning_platform/screens/admin/madrassa_crud_screen.dart';
import 'package:madressa_learning_platform/screens/admin/student_crud_screen.dart';
import 'package:madressa_learning_platform/screens/admin/teacher_crud_screen.dart';
import '../../controllers/auth_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final teacherCount = 9,
        courseCount = 14,
        madrassaCount = 5,
        studentCount = 250;
    final items = [
      _DashStat(
        icon: Icons.person_4,
        label: "Teachers",
        color: Colors.deepPurple,
        count: teacherCount,
        onTap: () => Get.to(() => const TeachersListScreen()),
      ),
      _DashStat(
        icon: Icons.menu_book,
        label: "Courses",
        color: Colors.indigo,
        count: courseCount,
        onTap: () => Get.to(() => const CoursesListScreen()),
      ),
      _DashStat(
        icon: Icons.apartment_rounded,
        label: "Madrassas",
        color: Colors.green,
        count: madrassaCount,
        onTap: () => Get.to(() => const MadrassasListScreen()),
      ),
      _DashStat(
        icon: Icons.school,
        label: "Students",
        color: Colors.blue,
        count: studentCount,
        onTap: () => Get.to(() => const StudentsListScreen()),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: Colors.blueGrey.shade800,
            tooltip: 'Logout',
            onPressed: () => _authController.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.10,
              child: Image.network(
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xEEFFFFFF),
                    Color(0x99E3F0FC),
                    Color(0xDEE3E8FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 36,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.network(
                              'https://randomuser.me/api/portraits/men/47.jpg',
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Dashboard',
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey.shade800,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 10,
                                      color: Colors.blueGrey.withOpacity(0.18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                'Control center for your learning ecosystem',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.blueGrey.shade600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 42),
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.1,
                      children: [
                        ...items.map((e) => _AnimatedDashStat(e: e)).toList(),
                      ],
                    ),
                    const SizedBox(height: 38),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashStat {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;
  _DashStat({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });
}

class _AnimatedDashStat extends StatefulWidget {
  final _DashStat e;
  const _AnimatedDashStat({required this.e});

  @override
  State<_AnimatedDashStat> createState() => _AnimatedDashStatState();
}

class _AnimatedDashStatState extends State<_AnimatedDashStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.e.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 32,
                spreadRadius: 0,
                color: widget.e.color.withOpacity(.15),
                offset: const Offset(0, 10),
              ),
            ],
            color: Colors.white.withOpacity(.82),
            border: Border.all(
              color: widget.e.color.withOpacity(0.11),
              width: 2,
            ),
            backgroundBlendMode: BlendMode.overlay,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        widget.e.color.withOpacity(.5),
                        widget.e.color.withOpacity(.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.e.color.withOpacity(.48),
                        blurRadius: 40,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(17),
                  child: Icon(widget.e.icon, color: widget.e.color, size: 38),
                ),
                const SizedBox(height: 18),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    final val =
                        (widget.e.count * _animation.value).clamp(0, widget.e.count).toInt();
                    return Text(
                      '$val',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: widget.e.color,
                        fontSize: 36,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: widget.e.color.withOpacity(.11),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 7),
                Text(
                  widget.e.label,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
