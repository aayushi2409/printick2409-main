import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printick/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../user/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _isPasswordVisible = false;

  late final AnimationController _entryController;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutQuart,
      ),
    );

    _cardFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  setState(() => isLoading = true);

  final result = await AuthService().login(
    email: emailController.text,
    password: passwordController.text,
  );

  setState(() => isLoading = false);

  if (!mounted) return;

  /// 🔥 Show message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF4D48FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      content: Row(
        children: [
          const Icon(Icons.login, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              result ?? "Done",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  /// 🚀 Navigate if success
  if (result == "Login successful") {

    final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
    await context.read<AppAuthProvider>().fetchUserProfile(user.uid);
  }
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const HomeScreen()),
); // later screen
  }
}

  @override
  Widget build(BuildContext context) {
    // const startColor = Color(0xFF4D48FF);
    const endColor = Color(0xFF7A64FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FF),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4D48FF), Color(0xFF7A64FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: -40,
              left: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 90,
              right: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
 Row(
  children: [
    Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.print_outlined,
        size: 28,
        color: Colors.white,
      ),
    ),

    const SizedBox(width: 14),

    const Expanded(
      child: Text(
        'Printick',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  ],
),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Sign in to your Printick dashboard.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SlideTransition(
                      position: _cardSlide,
                      child: FadeTransition(
                        opacity: _cardFade,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x16000000),
                                blurRadius: 26,
                                offset: Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Login to Printick',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Instant printing at your fingertips.',
                                style: TextStyle(
                                  color: Color(0xFF7A7A92),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildField(
                                controller: emailController,
                                hint: 'Email address',
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: passwordController,
                                hint: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      foregroundColor: endColor,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    child: const Text('Forgot password?'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF4D48FF),
                                          Color(0xFF7A64FF),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Center(
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        child: isLoading
                                            ? const SizedBox(
                                                key: ValueKey('loader'),
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.6,
                                                ),
                                              )
                                            : const Row(
                                                key: ValueKey('label'),
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Flexible(
      child: Text(
        'New to Printick?',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
           fontSize: 13,

          color: Color.fromARGB(255, 85, 85, 100),
        ),
      ),
    ),

   TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/signup');
  },
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero,
  ),
  child: ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [
        Color(0xFF4D48FF),
        Color(0xFF7A64FF),
      ],
    ).createShader(bounds),
    child: const Text(
      'Create account',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white, // required for shader
      ),
    ),
  ),
)
  ],
)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        suffixIcon: isPassword
    ? IconButton(
        icon: Icon(
          _isPasswordVisible
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded,
          color: _isPasswordVisible
              ? const Color(0xFF4D48FF)
              : const Color(0xFF7A7A95),
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      )
    : null,
        prefixIcon: Icon(icon, color: const Color(0xFF7A7A95)),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFACADB9)),
        filled: true,
        fillColor: const Color(0xFFF6F7FF),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}