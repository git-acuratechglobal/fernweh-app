import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/common/common.dart';
import '../../../utils/common/privacy_policy.dart';
import '../../location_permission/location_screen.dart';
import '../../location_permission/location_service.dart';
import '../../navigation/navigation_screen.dart';
import '../auth_state/auth_state.dart';
import '../signup/otp_verification/verification_screen.dart';
import '../signup/profile_setup/create_profile_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isVisible = true;
  final _fkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    ref.listenManual(authNotifierProvider, (previous, next) {
      switch (next) {
        case Verified(:final user) when previous is Loading:
          ref.read(userDetailProvider.notifier).update((state) => user);
          ref.invalidate(localStorageServiceProvider);
          context.navigateAndRemoveUntil(const NavigationScreen());
          break;
        case SignUpVerified(:final user) when previous is Loading:
          context.navigateTo(VerificationScreen(user.email.toString()));
          break;
        case OtpVerified(:final user) when previous is Loading:
          ref.read(userDetailProvider.notifier).update((state) => user);
          ref.invalidate(localStorageServiceProvider);
          context.navigateTo(CreateProfileScreen(user.email.toString()));
          break;
        case UserUpdated(:final user) when previous is Loading:
          ref.read(userDetailProvider.notifier).update((state) => user);
          final locationService = ref.watch(locationServiceProvider);
          print(locationService.isLocationPermissionGranted);
          if (!locationService.isLocationPermissionGranted) {
            context.navigateAndRemoveUntil(const LocationPermissionScreen());
            return;
          } else {
            ref.read(localStorageServiceProvider).clearGuestSession();
            context.navigateAndRemoveUntil(const NavigationScreen());
          }
          break;
        case Error(:final error):
          Common.showSnackBar(context, error.toString());
        default:
      }
    });
    super.initState();
  }

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
            key: _fkey,
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
                    'Sign in with socials or fill the form to continue',
                    style: TextStyle(
                      color: Color(0xFF494D60),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => validation.validateEmail(val),
                    decoration:
                        const InputDecoration(hintText: "Enter email address"),
                    onSaved: (String? val) {
                      ref
                          .read(authNotifierProvider.notifier)
                          .updateFormData('email', val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => validation.validatePassword(val),
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
                    onSaved: (String? val) {
                      ref
                          .read(authNotifierProvider.notifier)
                          .updateFormData('password', val);
                    },
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    isLoading: authState is Loading,
                    child: const Text("Submit"),
                    onTap: () {
                      if (_fkey.currentState!.validate()) {
                        _fkey.currentState?.save();
                        ref
                            .read(localStorageServiceProvider)
                            .clearGuestSession();
                        ref.read(authNotifierProvider.notifier).login();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          ref.read(localStorageServiceProvider).setGuestLogin();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavigationScreen()),
                            (Route<dynamic> route) =>
                                false, // This condition removes all previous routes
                          );
                        },
                        child: const Text('Skip Login')),
                  ),
                  const SizedBox(height: 24),
                  const PrivacyPolicyWidget(),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Color(0xFF81838B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () async{
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google.png'),
                        const SizedBox(width: 16.0),
                        const Text(
                          'Signup with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1A1B28),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/facebook.png'),
                        const SizedBox(width: 16.0),
                        const Text(
                          'Signup with Facebook',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1A1B28),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: 40,
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Don’t have an account? ',
                              style: TextStyle(
                                color: Color(0xFF494D60),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Signup Now!',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                  emailController.clear();
                                  passController.clear();
                                  _fkey.currentState?.reset();
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
