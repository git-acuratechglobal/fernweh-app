import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/common/privacy_policy.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/auth/auth_state/auth_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/common/app_button.dart';
import '../../../utils/common/app_mixin.dart';
import '../../../utils/common/app_validation.dart';
import 'otp_verification/verification_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with FormUtilsMixin {
  bool isVisible = true;
  bool isConfirmVisible = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(validatorsProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(gradient: Config.backgroundGradient),
          child: Form(
            key: fkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.viewPaddingOf(context).top + 16),
                  Image.asset('assets/images/logo.png'),
                  const SizedBox(height: 34),
                  const Text(
                    'Hi, Welcome to Fernweh',
                    style: TextStyle(
                      color: Color(0xFF1A1B28),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'Sign up the form to continue',
                    style: TextStyle(
                      color: Color(0xFF494D60),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    validator: (val) => validation.validateEmail(val),
                    decoration:
                        const InputDecoration(hintText: "Enter email address"),
                    onSaved: (val) => ref
                        .read(authNotifierProvider.notifier)
                        .updateFormData("email", val),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    obscureText: isVisible,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: switch (isVisible) {
                            true => Image.asset(
                                'assets/images/eye-slash.png',
                                key: const ValueKey(true),
                              ),
                            false => Image.asset(
                                'assets/images/eye.png',
                                key: const ValueKey(false),
                              ),
                          },
                        ),
                      ),
                    ),
                    validator: (val) => validation.validatePassword(val),
                    onSaved: (val) => ref
                        .read(authNotifierProvider.notifier)
                        .updateFormData("password", val),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: isConfirmVisible,
                    decoration: InputDecoration(
                      hintText: "Enter confirm password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmVisible = !isConfirmVisible;
                          });
                        },
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: switch (isConfirmVisible) {
                            true => Image.asset(
                                'assets/images/eye-slash.png',
                                key: const ValueKey(true),
                              ),
                            false => Image.asset(
                                'assets/images/eye.png',
                                key: const ValueKey(false),
                              ),
                          },
                        ),
                      ),
                    ),
                    validator: (val) => validation.validateConfirmPassword(
                        val, passwordController.text.toString()),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    isLoading: authState is Loading,
                    child: const Text("Submit"),
                    onTap: () {
                      if (validateAndSave()) {
                        ref.read(authNotifierProvider.notifier).signUp();
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  const PrivacyPolicyWidget(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Color(0xFF494D60),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In!',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                },
                              style: const TextStyle(
                                color: Color(0xFF12B347),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
