import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
      final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool _isPasswordVisible = false;

  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
  setState(() => isLoading = true);

  final result = await AuthService().signup(
    username: usernameController.text,
    email: emailController.text,
    password: passwordController.text,
  );

  setState(() => isLoading = false);

  if (!mounted) return;


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
        const Icon(Icons.mark_email_read, color: Colors.white),
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
}

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4D48FF);
    const secondary = Color(0xFF7A64FF);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            /// 🔥 Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// 🔵 Decorative Circles
            Positioned(
              top: -40,
              left: -30,
              child: _circle(130),
            ),
            Positioned(
              top: 100,
              right: -20,
              child: _circle(90),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔙 Back Button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    /// 🔥 Title
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Join Printick and Say Goodbye to long queues 😍",
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 30),

                    /// 🔥 Animated Card
                    SlideTransition(
                      position: _slide,
                      child: FadeTransition(
                        opacity: _fade,
                        child: Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildField(
  controller: usernameController,
  hint: "Name (Official)",
  icon: Icons.person_outline,
),
const SizedBox(height: 16),
                              _buildField(
                                controller: emailController,
                                hint: "Email",
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: passwordController,
                                hint: "Password",
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 20),

                              /// 🔥 Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _signup,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [primary, secondary],
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Center(
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              "Create Account",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// 🔁 Back to login
                             Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Flexible(
      child: Text(
        "Already have an account?",
        overflow: TextOverflow.ellipsis,
      ),
    ),

 TextButton(
  onPressed: () => Navigator.pop(context),
  style: TextButton.styleFrom(padding: EdgeInsets.zero),
  child: ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [
        Color(0xFF4D48FF),
        Color(0xFF7A64FF),
      ],
    ).createShader(bounds),
    child: const Text(
      "Login",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  ),
),
  ],
)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
    );
  }

 Widget _buildField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool isPassword = false,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4), // spacing between fields
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08), // 🔥 stronger shadow
          blurRadius: 15,                        // 🔥 softness
          offset: const Offset(0, 6),           // 🔥 depth (downward)
        ),
      ],
    ),
    child: TextField(
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
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF7A7A95),
        ),

        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFACADB9),
        ),

        filled: true,
        fillColor: Colors.white, // 🔥 IMPORTANT: pure white for shadow contrast

        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF4D48FF),
            width: 1.5,
          ),
        ),
      ),
    ),
  );
}
}