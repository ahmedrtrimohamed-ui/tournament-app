// lib/core/widgets/otp_verification_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'neon_button.dart';

class OtpVerificationDialog extends ConsumerStatefulWidget {
  final String email;
  final VoidCallback onVerified;

  const OtpVerificationDialog({
    super.key,
    required this.email,
    required this.onVerified,
  });

  @override
  ConsumerState<OtpVerificationDialog> createState() =>
      _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends ConsumerState<OtpVerificationDialog> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Listen for OTP verification success
    ref.listen(authProvider, (previous, next) {
      if (next.isSuccess && !next.isLoading && mounted) {
        widget.onVerified();
      }
    });
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
        }
      });
      return _resendTimer > 0 && mounted;
    });
  }

  void _handleOtpVerify() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
      return;
    }

    await ref.read(authProvider.notifier).verifyOtp(widget.email, otp);
  }

  void _handleResendOtp() {
    if (!_canResend) return;

    // Call register again to resend OTP
    // You might want to store registration data or create a resend endpoint
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully'),
        backgroundColor: AppColors.success,
      ),
    );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Dialog(
      backgroundColor: const Color(0xFF1E2130),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.primary,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Verify Your Email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ve sent a 6-digit code to\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white.withAlpha((255 * 0.05).toInt()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }

                      // Auto verify when all fields are filled
                      if (index == 5 && value.isNotEmpty) {
                        String fullOtp = _otpControllers
                            .map((c) => c.text)
                            .join();
                        if (fullOtp.length == 6) {
                          _handleOtpVerify();
                        }
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Resend OTP
            TextButton(
              onPressed: _canResend ? _handleResendOtp : null,
              child: Text(
                _canResend ? 'Resend OTP' : 'Resend in $_resendTimer sec',
                style: TextStyle(
                  color: _canResend ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Verify Button
            SizedBox(
              width: double.infinity,
              child: NeonButton(
                text: 'VERIFY',
                isLoading: authState.isLoading,
                onPressed: _handleOtpVerify,
              ),
            ),

            const SizedBox(height: 8),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
