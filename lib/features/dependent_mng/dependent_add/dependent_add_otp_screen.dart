import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/signup/controller/sign_up_controller.dart';
import 'package:goshare/features/signup/widgets/otp_form.dart';
import 'package:goshare/theme/pallet.dart';

class DependentAddOtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const DependentAddOtpScreen({
    super.key,
    required this.phone,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<DependentAddOtpScreen> {
  late Timer _countdownTimer;
  int _countdown = Constants.otpResendTimeout;
  bool _isResendButtonDisabled = true;
  bool _isSubmitButtonDisabled = true;
  bool _isLoading = false;
  String otp = '';
  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _countdownTimer.cancel();
        setState(() {
          _isResendButtonDisabled = false;
        });
      }
    });
  }

  void resendOtp(String phone) async {
    final result =
        await ref.read(signUpControllerProvider.notifier).reSendOtpVerification(
              phone,
              context,
            );
    if (result) {
      setState(() {
        _isResendButtonDisabled = true;
        _countdown = Constants.otpResendTimeout; // Reset the countdown
        startCountdown();
      });
    }
  }

  String formatCountdown(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes phút $remainingSeconds giây';
  }

  void _onSubmit(
    WidgetRef ref,
    String phone,
    String otp,
    BuildContext context,
  ) async {
    setState(() {
      _isLoading = true;
    });
    final result =
        await ref.read(signUpControllerProvider.notifier).sendOtpVerification(
              phone,
              otp,
              context,
            );
    setState(() {
      _isLoading = false;
    });
    if (result != null && result.trim().isNotEmpty) {
      navigateToSetPassCodeScreen(phone, result);
    } else {
      // print('loi roi huhu');
    }
  }

  void navigateToSetPassCodeScreen(String phone, String setToken) {
    context.goNamed(RouteConstants.passcode, pathParameters: {
      'phone': phone,
      'setToken': setToken,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: HomeCenterContainer(
                  verticalPadding: 30,
                  horizontalPadding: 30,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Mã xác nhận',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Chúng tôi đã gửi mã xác nhận đến',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              // color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.phone,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OtpForm(
                        onFinish: (otpValue) {
                          if (otpValue.length == 6) {
                            setState(() {
                              _isSubmitButtonDisabled = false;
                              otp = otpValue;
                            });
                          }
                        },
                        onChange: () {},
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: 'Có thể gửi lại mã trong: ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: formatCountdown(_countdown),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Pallete
                                    .primaryColor, // Change the color as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isResendButtonDisabled
                                  ? null
                                  : () => resendOtp(widget.phone),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 0,
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Pallete.primaryColor),
                              ),
                              child: const Text(
                                'Gửi lại',
                                style: TextStyle(
                                  color: Pallete.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSubmitButtonDisabled
                                  ? null
                                  : () => _onSubmit(
                                        ref,
                                        widget.phone,
                                        otp,
                                        context,
                                      ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Xác nhận',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Loader(),
          ),
      ],
    );
  }
}
