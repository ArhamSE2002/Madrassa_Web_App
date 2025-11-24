import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Start initialization when widget is inserted
    Future.delayed(Duration.zero, () {
      _initializeApp();
    });

    return Scaffold( // For future: put this into a container
      body: Container(
        
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Splash icon as circular avatar for a modern look
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(Icons.school, size: 100, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Text(
                'Madressa Learning Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Empowering through Education',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.6),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    final AuthController authController = Get.put(AuthController(), permanent: true);

    await Future.delayed(const Duration(seconds: 2));
    await authController.checkAuthStatus();

    if (!authController.isAuthenticated) {
      Get.offAll(() => LoginScreen());
    } else {
      // You can also add navigation logic to go to Home if authenticated
      // Get.offAll(() => HomeScreen());
    }
  }
}
