import 'dart:async';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/profile/presentation/screens/onboarding_flow.dart';
import 'package:archflow/shared/widgets/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 4;
  static const int _resendDelay = 30;
  static const int _maxAttempts = 3;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  int _secondsRemaining = _resendDelay;
  int _attemptsLeft = _maxAttempts;
  bool _canResend = false;
  bool _isVerifying = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _canResend = false;
      _secondsRemaining = _resendDelay;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String _getOtp() => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_isVerifying || _attemptsLeft == 0) return;

    final otp = _getOtp();
    if (otp.length != _otpLength) return;

    setState(() => _isVerifying = true);

    await Future.delayed(const Duration(milliseconds: 800));
    final bool isValidOtp = otp == '1234'; // replace with API

    if (!mounted) return;

    if (!isValidOtp) {
      setState(() {
        _attemptsLeft--;
        _isVerifying = false;
      });

      AppSnackBar.show(
        context,
        icon: Icons.mark_email_read_outlined,
        message: _attemptsLeft == 0
            ? 'Too many attempts. Please resend OTP.'
            : 'Invalid OTP. Attempts left: $_attemptsLeft',
      );
      return;
    }

    setState(() => _isVerifying = false);

    for (final c in _controllers) {
      c.clear();
    }
    for (final f in _focusNodes) {
      f.unfocus();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingFlow()),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (index == _otpLength - 1 && value.isNotEmpty) {
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            Text(
              'OTP code verification 🔐',
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'We’ve sent a verification code to\n${widget.email}',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_otpLength, (index) {
                return SizedBox(
                  width: 56,
                  height: 56,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.brandGreen,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (v) => _onOtpChanged(v, index),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            Center(
              child: Column(
                children: [
                  Text("Didn't receive the code?", style: GoogleFonts.lato()),
                  const SizedBox(height: 8),
                  _canResend
                      ? TextButton(
                          onPressed: () {
                            _attemptsLeft = _maxAttempts;
                            for (var c in _controllers) {
                              c.clear();
                            }
                            _startResendTimer();
                          },
                          child: Text(
                            'Resend code',
                            style: GoogleFonts.lato(
                              color: AppColors.brandGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Text(
                          'Resend in $_secondsRemaining s',
                          style: GoogleFonts.lato(color: AppColors.brandGreen),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
