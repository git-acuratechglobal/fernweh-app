import 'package:flutter/material.dart';
import 'extensions.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.value, required this.onPressed});

  final bool value;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      heroTag: null,
      shape: const StadiumBorder(),
      backgroundColor: Colors.black,
      onPressed: onPressed,
      icon: Image.asset(
          value ? 'assets/images/task.png' : 'assets/images/map.png'),
      label: Text(
        value ? "ListView" : "MapView",
        style: TextStyle(
          color: Colors.white,
          fontVariations: FVariations.w800,
        ),
      ),
    );
  }
}
