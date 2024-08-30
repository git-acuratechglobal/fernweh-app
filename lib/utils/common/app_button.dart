import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.isLoading,
    this.onTap,
    required this.child,
    this.size
  });
final Size? size;
  final Widget child;
  final bool isLoading;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: size,
            elevation: 0, backgroundColor: const Color(0xff1A72FF)),
        child: switch (isLoading) {
          false => child,
          true => LoadingAnimationWidget.twistingDots(
              size: 30,
              leftDotColor: const Color(0xFFCF5253),
              rightDotColor: const Color(0xff1A72FF),
            )
        });
  }
}
