import 'dart:io';
import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../services/local_storage_service/local_storage_service.dart';
import '../../../../../../utils/common/extensions.dart';
import '../../../../../auth/signup/profile_setup/create_profile_screen.dart';
import '../../../models/states/itinerary_state.dart';
import '../../../notifier/itinerary_notifier.dart';

class EditItenerary extends ConsumerStatefulWidget {
   EditItenerary(
      {super.key,
      required this.iteneraryName,
      required this.iteneraryPhoto,
        required this.type,
      this.id});

  final String iteneraryName;
  final String iteneraryPhoto;
   int type;
  final int? id;

  @override
  ConsumerState<EditItenerary> createState() => _EditIteneraryState();
}

class _EditIteneraryState extends ConsumerState<EditItenerary>
    with FormUtilsMixin {
  XFile? file;

  List<(String? name, int? type)> typeList = [
    ("Private", 0),
    ("Public", 1),
  ];
  @override
  Widget build(BuildContext context) {
    ref.listen(userItineraryNotifierProvider, (previous, next) {
      switch (next) {
        case Saved() when previous is SavedLoading:
          Navigator.of(context).pop();
          Common.showSnackBar(context, "Collection updated successfully");
        case Deleted() when previous is DeleteLoading:
          Navigator.of(context).pop();
          Common.showSnackBar(context, "Collection deleted successfully");

        case UserItineraryError(:final error):
          Common.showSnackBar(context, error.toString());
        default:
      }
    });
    final state = ref.watch(userItineraryNotifierProvider);
    final savedItineraryId =
    ref.watch(localStorageServiceProvider).getItineraryId();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    Text(
                      'Edit Collection',
                      style: TextStyle(
                        color: const Color(0xFF1A1B28),
                        fontSize: 20,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                    const SizedBox.square(dimension: 40)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.iteneraryName,
                onSaved: (val) {
                  ref
                      .read(userItineraryNotifierProvider.notifier)
                      .updateForm('name', val);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: switch (file) {
                        XFile image => Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                          ),
                        null => ImageWidget(
                            url: widget.iteneraryPhoto,
                          )
                      }),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  final pickedImage = await showDialog(
                    context: context,
                    builder: (context) {
                      return const ImagePickerOptions();
                    },
                  );
                  if (pickedImage != null) {
                    setState(() {
                      file = pickedImage;
                    });
                    ref
                        .read(userItineraryNotifierProvider.notifier)
                        .updateForm('image', pickedImage);
                  }
                },
                child: const Text(
                  "Change Collection Image",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Image.asset('assets/images/global.png'),
                    const SizedBox(width: 12.0),
                    DropdownButton(
                      value: widget.type,
                      underline: const SizedBox.shrink(),
                      items: typeList.map((e) {
                        return DropdownMenuItem(
                          value: e.$2,
                          child: Text(e.$1.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          widget.type = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 05,
              ),
              AppButton(
                isLoading: state is SavedLoading,
                child: const Text('Save Collection'),
                onTap: () {
                  if (validateAndSave()) {
                    ref
                        .read(userItineraryNotifierProvider.notifier)
                        .updateForm('type', widget.type);
                    ref
                        .read(userItineraryNotifierProvider.notifier)
                        .updateForm('id', widget.id);
                    ref
                        .read(userItineraryNotifierProvider.notifier)
                        .updateItinerary();
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                isLoading: state is DeleteLoading,
                child: const Text('Delete Collection'),
                onTap: () {
                  if (validateAndSave()) {
                    ref
                        .read(userItineraryNotifierProvider.notifier)
                        .updateForm('id', widget.id);
                    ref
                        .read(userItineraryNotifierProvider.notifier)
                        .deleteItinerary();
                    if(savedItineraryId==widget.id){
                      ref.read(localStorageServiceProvider).clearSavedItineraryId();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
