import 'package:flutter/cupertino.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "By submitting, I accept Fernweh's ",
              style: TextStyle(
                color: Color(0xFF494D60),
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Terms of use',
              style: TextStyle(
                color: Color(0xFF1A1B28),
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: ' & ',
              style: TextStyle(
                color: Color(0xFF494D60),
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: Color(0xFF1A1B28),
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: '.',
              style: TextStyle(
                color: Color(0xFF494D60),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
