import 'package:fernweh/utils/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/local_storage_service/local_storage_service.dart';
import '../../../utils/common/config.dart';
import '../../auth/login/login_screen.dart';

class GuestLogin extends ConsumerWidget {
  const GuestLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(gradient: Config.backgroundGradient),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "You'r not login! please login",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppButton(
              isLoading: false,
              child: const Text('Login'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            )
          ],
        ),
      ),
    ));
  }
}
