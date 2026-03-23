import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
        _emailSent = true;
      });
    });
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
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),

                const SizedBox(height: 32),

                Text(
                  'Forgot Password',
                  style: AppTextStyles.h1Light.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Enter your email address and we\'ll send you a link to reset your password',
                  style: AppTextStyles.bodyMediumLight.copyWith(
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _emailSent
                          ? Icons.check_circle_outline
                          : Icons.mail_outline_rounded,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                if (!_emailSent) ...[
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

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Send Reset Link',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ] else ...[
                  Center(
                    child: Text(
                      'Reset Link Sent!',
                      style: AppTextStyles.h2Light.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      'Check your email inbox and follow the instructions set your password',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMediumLight.copyWith(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteNames.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        _emailSent = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Resend Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                if (!_emailSent)
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Need help ? Contact Support',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
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
