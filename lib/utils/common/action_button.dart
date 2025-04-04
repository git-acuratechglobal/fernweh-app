import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.value, required this.onPressed});

  final bool value;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      heroTag: null,
      shape: const StadiumBorder(),
      backgroundColor: Colors.black,
      onPressed: onPressed,
      child: Image.asset(
          value ? 'assets/images/task.png' : 'assets/images/map.png'),
    );
  }
}
