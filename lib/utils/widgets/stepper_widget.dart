import 'package:flutter/material.dart';

class StepperWidget extends StatelessWidget {
  final int currentPage;

  const StepperWidget({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: List.generate(
          2,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              height: 4,
              decoration: ShapeDecoration(
                color: index <= currentPage
                    ? Theme.of(context).colorScheme.tertiary
                    : const Color(0xffE2E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
