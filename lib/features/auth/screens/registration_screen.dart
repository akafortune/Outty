import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/core/widdgets/custom_button.dart';

import '../FirebaseMethods/auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  final User? user = Auth().currentUser;
  String? errorMessage = '';

  void register() async {
    try {
      await authService.value.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushNamed(context, RouteNames.onboarding);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3],
            colors: isDarkMode
                ? [AppColors.cardDark, AppColors.backgroundDark]
                : [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: textColor),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                const SizedBox(height: 24),

                Text(
                  'Create Account',
                  style: AppTextStyles.h1Light.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Find your perfect match today',
                  style: AppTextStyles.bodyLargeLight.copyWith(
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: isDarkMode
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: isDarkMode
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: isDarkMode
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.7),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of service',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Create Account',
                  onPressed: _agreeToTerms
                      ? () {
                          register();
                        }
                      : null,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or sign up with',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialSignUpButton(
                      icon: Icons.g_mobiledata_rounded,
                      color: isDarkMode ? Colors.white : Colors.black,
                      onPressed: () {},
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 20),
                    _socialSignUpButton(
                      icon: Icons.apple_rounded,
                      color: isDarkMode ? Colors.white : Colors.black,
                      onPressed: () {},
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 20),
                    _socialSignUpButton(
                      icon: Icons.facebook_rounded,
                      color: Color(0xFF1877F2),
                      onPressed: () {},
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.login);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialSignUpButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey.shade800.withOpacity(0.5)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}
