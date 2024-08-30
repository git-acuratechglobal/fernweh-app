import 'package:flutter/material.dart';

mixin FormUtilsMixin {
  final fkey = GlobalKey<FormState>();

  bool validateAndSave() {
    final validated = fkey.currentState?.validate();
    if (validated != null && validated) {
      fkey.currentState!.save();
      return true;
    }
    return false;
  }
}
