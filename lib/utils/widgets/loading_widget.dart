import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.twistingDots(
      size: 30,
      leftDotColor: const Color(0xFFCF5253),
      rightDotColor: const Color(0xff1A72FF),
    );
  }
}
