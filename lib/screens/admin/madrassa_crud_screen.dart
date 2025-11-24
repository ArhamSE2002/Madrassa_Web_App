import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_card.dart';
import '../../controllers/auth_controller.dart';
import '../admin/user_detail_screen.dart';
import '../../data/mock_madrassas.dart';

class MadrassasListScreen extends StatefulWidget {
  const MadrassasListScreen({Key? key}) : super(key: key);

  @override
  State<MadrassasListScreen> createState() => _MadrassasListScreenState();
}

class _MadrassasListScreenState extends State<MadrassasListScreen>
    with SingleTickerProviderStateMixin {
  List<UserModel> madrassas = [];
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
    madrassas = mockMadrassas
        .map((m) => UserModel(
              id: m.id,
              name: m.name,
              email: '${m.name.toLowerCase().replaceAll(' ', '')}@mail.com',
              role: UserRole.madrassa,
              madrassaName: m.address,
              createdAt: DateTime.now().subtract(const Duration(days: 300)),
            ))
        .toList();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addMadrassa() {
    setState(() {
      madrassas.add(
        UserModel(
          id: 'M${madrassas.length + 1}',
          name: 'New Madrassa',
          email: 'madrassa${madrassas.length + 1}@mail.com',
          role: UserRole.madrassa,
          madrassaName: 'New City',
          createdAt: DateTime.now(),
        ),
      );
      _animController.reset();
      _animController.forward();
    });
  }

  void _deleteMadrassa(UserModel user) =>
      setState(() => madrassas.remove(user));
  @override
  Widget build(BuildContext context) {
    final filtered = madrassas.where((m) =>
      m.name.toLowerCase().contains(search.toLowerCase()) ||
      m.email.toLowerCase().contains(search.toLowerCase()) ||
      (m.madrassaName?.toLowerCase().contains(search.toLowerCase()) ?? false)
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Madrassas',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add),
        elevation: 16,
        onPressed: _addMadrassa,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Material(
              elevation: 8,
              shadowColor: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search Madrassa...",
                  hintStyle: GoogleFonts.poppins(color: Colors.green.shade200),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                    duration: const Duration(milliseconds: 780),
                    curve: Curves.easeInCubic,
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
                        onDelete: () => _deleteMadrassa(filtered[idx]),
                        badgeText: 'Madrassa',
                        showMadrassaLogo: true,
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
