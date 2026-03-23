import 'dart:async';

import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/core/widdgets/custom_button.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendSeconds = 60;
  Timer? _timer;
  bool _isVerifying = false;

  void initState() {
    super.initState();
    _startResendTimer();

    for (int i = 0; i < _focusNodes.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < _focusNodes.length - 1) {
          _focusNodes[i].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          timer?.cancel();
        }
      });
    });
  }

  void _verifyCode() {
    setState(() {
      _isVerifying = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.onboarding,
        (route) => false,
      );
    });
  }

  void _resendCode() {
    setState(() {
      _resendSeconds = 60;
    });
    _startResendTimer();
  }

  void dispose() {
    _timer?.cancel();

    for (var controller in _controllers) {
      controller.dispose();
    }

    for (var node in _focusNodes) {
      node.dispose();
    }
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
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
                ),

                const SizedBox(height: 32),

                Text(
                  'Verification',
                  style: AppTextStyles.h1Light.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'We\'ve sent a verification code to your email address',
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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.verified_user_outlined,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 64,
                      height: 64,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey.shade800.withValues(alpha: 0.5)
                              : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index].unfocus();
                            FocusScope.of(
                              context,
                            ).requestFocus(_focusNodes[index - 1]);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Verify',
                  isLoading: _isVerifying,
                  onPressed: _verifyCode,
                ),

                const SizedBox(height: 24),

                Center(
                  child: Column(
                    children: [
                      Text(
                        'Didn\'t receive the code?',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: _resendSeconds == 0 ? _resendCode : null,
                        child: Text(
                          _resendSeconds > 0
                              ? 'Resend code in $_resendSeconds seconds'
                              : 'Resend Code',
                          style: TextStyle(
                            color: _resendSeconds > 0
                                ? isDarkMode
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade600
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Need help? Contact Support',
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
