import 'package:flutter/material.dart';

class GenderFormField extends FormField<String> {
  final BuildContext context;

  GenderFormField({
    super.key,
    required this.context,
    super.onSaved,
    super.validator,
    super.initialValue = "male",
    bool autovalidate = false,
  }) : super(
          builder: (FormFieldState<String> state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      state.didChange("male");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: state.value == "male"
                            ? const Color(0xffFFE9E9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 2,
                          color: state.value == "male"
                              ? const Color(0xffCF5253)
                              : const Color(0xffE2E2E2),
                        ),
                      ),
                      child: Text(
                        "Male",
                        style: TextStyle(
                          fontSize: 14,
                          color: state.value == "male"
                              ? const Color(0xffCF5253)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      state.didChange("female");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: state.value == "female"
                            ? const Color(0xffFFE9E9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 2,
                          color: state.value == "female"
                              ? const Color(0xffCF5253)
                              : const Color(0xffE2E2E2),
                        ),
                      ),
                      child: Text(
                        "Female",
                        style: TextStyle(
                          color: state.value == "female"
                              ? const Color(0xffCF5253)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      state.didChange("other");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: state.value == "other"
                            ? const Color(0xffFFE9E9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 2,
                          color: state.value == "other"
                              ? const Color(0xffCF5253)
                              : const Color(0xffE2E2E2),
                        ),
                      ),
                      child: Text(
                        "Other",
                        style: TextStyle(
                          color: state.value == "other"
                              ? const Color(0xffCF5253)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
}
