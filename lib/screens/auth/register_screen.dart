import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/responsive.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _madressaController = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController(), permanent: true);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _madressaController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authController.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _selectedRole,
          _selectedRole == UserRole.student ? _madressaController.text : null,
          _selectedRole == UserRole.student ? 'madrassa-123' : null,
        );
        if (!mounted) return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade700,
                    Colors.indigo.shade800,
                    Colors.blue.shade600,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Opacity(
                opacity: 0.12,
                child: Image.network(
                  'https://images.unsplash.com/photo-1522202176988-66273c2fd55f',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ),
          Responsive(
            mobile: _buildMobileLayout(),
            desktop: _buildDesktopLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildRegisterForm(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: _buildRegisterForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (Responsive.isMobile(context)) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(Icons.person_add, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'Create Account',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: TextFormField(
              controller: _nameController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.person_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.purple.shade400,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: TextFormField(
              controller: _emailController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.email_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.purple.shade400,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: TextFormField(
              controller: _passwordController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.purple.shade400,
                    width: 2,
                  ),
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.badge_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.purple.shade400,
                    width: 2,
                  ),
                ),
              ),
              style: GoogleFonts.poppins(),
              items: UserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(
                    role.toString().split('.').last.toUpperCase(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
          ),
          if (_selectedRole == UserRole.student) ...[
            const SizedBox(height: 16),
            Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _madressaController,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  labelText: 'Madressa Name',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.school_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.purple.shade400,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (_selectedRole == UserRole.student && (value == null || value.isEmpty)) {
                    return 'Please enter your Madressa name';
                  }
                  return null;
                },
              ),
            ),
          ],
          const SizedBox(height: 32),
          Obx(() {
            final isLoading = _authController.isLoading.value;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.indigo.shade600],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
