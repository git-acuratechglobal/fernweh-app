import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/widgets/gender_form_field.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/auth/signup/profile_setup/profile_step/profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/common/extensions.dart';
import '../../../../utils/widgets/picker_form_field.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen(this.email, {super.key});

  final String email;

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen>
    with FormUtilsMixin {
  String countryCode = "1";
  XFile? file;
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(validatorsProvider);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF494D60),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: fkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Setup your profile',
                        style: TextStyle(
                          color: const Color(0xFF1A1B28),
                          fontSize: 24,
                          fontVariations: FVariations.w700,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Please fill your personal details below',
                        style: TextStyle(
                          color: Color(0xFF494D60),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ClipOval(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: switch (file) {
                                XFile image => Image.file(
                                    File(image.path),
                                    fit: BoxFit.cover,
                                  ),
                                null => Image.asset(
                                    'assets/images/image.png',
                                    fit: BoxFit.cover,
                                  ),
                              }),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () async {
                            final pickedImage = await showDialog(
                              context: context,
                              builder: (context) {
                                return const ImagePickerOptions();
                              },
                            );
                            if (pickedImage != null) {
                              ref
                                  .read(authNotifierProvider.notifier)
                                  .updateFormData("image", pickedImage);
                              setState(() {
                                file = pickedImage;
                              });
                            }
                          },
                          child: Text(
                            "Add Your Profile Picture",
                            style: TextStyle(fontVariations: FVariations.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                          decoration:
                              const InputDecoration(hintText: "Full name"),
                          validator: (val) => validation.validateName(val),
                          onSaved: (val) => ref
                              .read(authNotifierProvider.notifier)
                              .updateFormData("name", val)),
                      const SizedBox(height: 24),
                      TextFormField(
                        readOnly: true,
                        initialValue: widget.email,
                        decoration:
                            const InputDecoration(hintText: "Email address"),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        focusNode:_focusNode,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: "Phone number",
                            counterText: "",
                            prefixIcon: InkWell(
                              onTap: () async {
                                countryCodePicker(context, (code) {
                                  setState(() {
                                    countryCode = code.phoneCode;
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "+$countryCode",
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_drop_down_outlined)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (val) => validation.validateMobile(val),
                          onSaved: (val) => ref
                              .read(authNotifierProvider.notifier)
                              .updateFormData("phone", val),onTapOutside: (val){
                          _focusNode.unfocus();
                      },),
                      const SizedBox(height: 16),
                      Text(
                        'Gender',
                        style: TextStyle(
                          color: const Color(0xFF1A1B28),
                          fontSize: 16,
                          fontVariations: FVariations.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GenderFormField(
                        context: context,
                        validator: (val) => validation.validateGender(val),
                        onSaved: (val) => ref
                            .read(authNotifierProvider.notifier)
                            .updateFormData("gender", val),
                      ),
                      const SizedBox(height: 16),
                      PickerFormField<DateTime>(
                        context: context,
                        validator: (value) =>
                            value == null ? "Field Required" : null,
                        hint: "Date of birth",
                        suffix: Image.asset("assets/images/note.png"),
                        onSelect: (value) async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now(),
                          );
                          return picked;
                        },
                        onSaved: (val) => ref
                            .read(authNotifierProvider.notifier)
                            .updateFormData(
                                "dob", "${val!.day}/${val.month}/${val.year}"),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        isLoading: false,
                        child: const Text("Submit"),
                        onTap: () {
                          if (validateAndSave()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSetupScreen()));
                          }
                        },
                      ),
                      const SizedBox(height: 34),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<dynamic> countryCodePicker(
    BuildContext context, Function(Country) onSelect) async {
  showCountryPicker(
    context: context,
    favorite: ["US", "UK"],
    showPhoneCode: true,
    onSelect: onSelect,
    searchAutofocus: false,
    countryListTheme: CountryListThemeData(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      inputDecoration: InputDecoration(
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        labelText: 'Search',
        hintText: 'Search country',
        prefixIcon: const Icon(
          Icons.search,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    ),
  );
}

class ImagePickerOptions extends StatelessWidget {
  const ImagePickerOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "Select source",
      ),
      actions: [
        ListTile(
          title: const Text("Camera"),
          leading: const Icon(Icons.camera_alt, color: Colors.black),
          onTap: () {
            final picker = ImagePicker();
            picker
                .pickImage(source: ImageSource.camera, imageQuality: 70)
                .then((value) {
              Navigator.of(context).pop(value);
            });
          },
        ),
        ListTile(
          title: const Text("Gallery"),
          leading: const Icon(Icons.image, color: Colors.black),
          onTap: () {
            final picker = ImagePicker();
            picker
                .pickImage(source: ImageSource.gallery, imageQuality: 70)
                .then((value) {
              Navigator.of(context).pop(value);
            });
          },
        ),
      ],
    );
  }
}
