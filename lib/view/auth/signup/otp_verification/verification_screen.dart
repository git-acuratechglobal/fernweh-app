import 'dart:async';
import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/common/extensions.dart';
import '../../auth_state/auth_state.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen(this.email, {super.key});

  final String email;

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen>
    with FormUtilsMixin {
  Duration _duration = const Duration(minutes: 1);
  Timer? _timer;
late final ProviderSubscription otpVerification;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(validatorsProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF494D60),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: fkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'OTP Verification',
                      style: TextStyle(
                        color: const Color(0xFF1A1B28),
                        fontSize: 24,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Please enter OTP sent to your registered email address (${widget.email}) to complete your verification.',
                      style: const TextStyle(
                        color: Color(0xFF494D60),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Pinput(
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: 55,
                          height: 56,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(30, 60, 87, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffE2E2E2)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 55,
                          height: 56,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(30, 60, 87, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffE2E2E2)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (val) => validation.validateOTP(val),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) {
                          ref
                              .read(authNotifierProvider.notifier)
                              .updateFormData("email", widget.email);
                          ref
                              .read(authNotifierProvider.notifier)
                              .updateFormData("otp", pin);
                        }),
                    const SizedBox(height: 24),
                    AppButton(
                      isLoading: authState is Loading,
                      child: const Text('Verify'),
                      onTap: () {
                        if (validateAndSave()) {
                          ref.read(authNotifierProvider.notifier).matchOtp();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _duration.isNegative
                          ? () {
                              setState(() {
                                _duration = const Duration(minutes: 1);
                              });
                              startTimer();
                            }
                          : null,
                      child: const Text("Resend Code"),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Remaining time: ',
                              style: TextStyle(
                                color: Color(0xFF494D60),
                              ),
                            ),
                            TextSpan(
                              text: timerDetail(),
                              style: TextStyle(
                                color: const Color(0xFF12B347),
                                fontVariations: FVariations.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final seconds = _duration.inSeconds - 1;
      if (seconds < 0) {
        _timer?.cancel();
      }
      setState(() {
        _duration = Duration(seconds: seconds);
      });
    });
  }

  String timerDetail() {
    if (_duration.isNegative) return "00:00s";
    String minutes =
        _duration.inMinutes.remainder(60).toString().padLeft(2, "0");
    String seconds =
        _duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    return "$minutes:${seconds}s";
  }
}
