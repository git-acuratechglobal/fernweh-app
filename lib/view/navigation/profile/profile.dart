import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/auth/auth_state/auth_state.dart';
import 'package:fernweh/view/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../utils/common/common.dart';
import '../../../utils/common/config.dart';
import '../../../utils/common/extensions.dart';
import '../../../utils/widgets/gender_form_field.dart';
import '../../../utils/widgets/loading_widget.dart';
import '../../../utils/widgets/picker_form_field.dart';
import '../../auth/signup/profile_setup/create_profile_screen.dart';
import '../map/notifier/category_notifier.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> with FormUtilsMixin {
  String countryCode = "1";
  XFile? file;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailProvider);
    final authState = ref.watch(authNotifierProvider);
    final validation = ref.watch(validatorsProvider);
    ref.listen(authNotifierProvider, (previous, next) {
      switch (next) {
        case Verified(:final user) when previous is Loading:
          ref.read(userDetailProvider.notifier).update((state) => user);
        case UserUpdated(:final user) when previous is Loading:
          ref.read(userDetailProvider.notifier).update((state) => user);
          Common.showSnackBar(context, "Profile updated successfully");
        case Logout(:final message) when previous is LogoutLoading:
          ref.read(localStorageServiceProvider).clearSession();
          ref.invalidate(filtersProvider);
          ref.invalidate(localStorageServiceProvider);
          ref.invalidate(mapViewStateProvider);
          Common.showSnackBar(context, message);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        case Error(:final error):
          Common.showSnackBar(context, error.toString());
        default:
      }
    });
    return Stack(
      children: [
        Scaffold(
            body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(gradient: Config.backgroundGradient),
          child: Form(
            key: fkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    centerTitle: false,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_outlined),
                          onSelected: (value) {
                            switch (value) {
                              case "Logout":
                                ref
                                    .read(authNotifierProvider.notifier)
                                    .logOut();
                              case "Delete Account":
                              default:
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              'Logout',
                              'Delete Account',
                            ].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 125,
                    height: 125,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: user?.name == null && file == null
                        ? Image.asset("")
                        : ClipOval(
                            child: file == null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        'http://fernweh.acublock.in/public/${user?.image}',
                                    placeholder: (context, url) =>
                                        const Padding(
                                      padding: EdgeInsets.all(30.0),
                                      child: LoadingWidget(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(
                                      file!.path,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
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
                      " Edit Profile Picture",
                      style: TextStyle(fontVariations: FVariations.w600),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      validator: (val) => validation.validateName(val),
                      initialValue: user?.name,
                      onSaved: (val) => ref
                          .read(authNotifierProvider.notifier)
                          .updateFormData("name", val),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: user?.email,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        initialValue: user?.phone,
                        keyboardType: TextInputType.phone,
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
                        onSaved: (val) => ref
                            .read(authNotifierProvider.notifier)
                            .updateFormData("phone", val)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Gender',
                        style: TextStyle(
                          color: const Color(0xFF1A1B28),
                          fontSize: 16,
                          fontVariations: FVariations.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GenderFormField(
                      initialValue: user?.gender,
                      context: context,
                      onSaved: (val) => ref
                          .read(authNotifierProvider.notifier)
                          .updateFormData("gender", val),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Date of birth',
                        style: TextStyle(
                          color: const Color(0xFF1A1B28),
                          fontSize: 16,
                          fontVariations: FVariations.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PickerFormField<DateTime>(
                      initialValue: parseDate(user?.dob),
                      context: context,
                      validator: (value) =>
                          value == null ? "Field Required" : null,
                      hint: "Date of birth",
                      suffix: Image.asset("assets/images/note.png"),
                      onSelect: (value) async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: value,
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now(),
                        );
                        if (picked == null) {
                          return parseDate(user?.dob);
                        } else {
                          return picked;
                        }
                      },
                      onSaved: (val) => ref
                          .read(authNotifierProvider.notifier)
                          .updateFormData(
                              "dob", "${val!.day}/${val.month}/${val.year}"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      isLoading: authState is Loading,
                      child: const Text('Update Profile'),
                      onTap: () {
                        if (validateAndSave()) {
                          ref.read(authNotifierProvider.notifier).updateUser();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        )),
        Visibility(
            visible: authState is LogoutLoading,
            child: const Scaffold(
              backgroundColor: Colors.black45,
              body: Center(child: LoadingWidget()),
            )),
      ],
    );
  }

  DateTime? parseDate(String? dateString) {
    if (dateString == null) return null;
    // Adjust the format according to your date string format
    final DateFormat format = DateFormat('dd/MM/yyyy');
    return format.parse(dateString);
  }
}
