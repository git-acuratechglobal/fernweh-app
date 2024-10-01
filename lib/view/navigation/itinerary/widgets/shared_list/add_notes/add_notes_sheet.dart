import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/add_notes/notifier/notes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../utils/common/common.dart';
import '../../../../../../utils/common/extensions.dart';
import 'model/notes_model.dart';

class AddNotesSheet extends ConsumerStatefulWidget {
  const AddNotesSheet({
    super.key,
    required this.itineraryId,
  });

  final int itineraryId;

  @override
  ConsumerState<AddNotesSheet> createState() => _AddNotesSheetState();
}

class _AddNotesSheetState extends ConsumerState<AddNotesSheet> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual(addNotesProvider, (previous, next) {
      switch (next) {
        case AsyncData<String?> data when data.value != null:
          Common.showSnackBar(context, data.value.toString());
          noteController.clear();
        // Navigator.of(context).pop();
        case AsyncError error:
          Common.showSnackBar(context, error.error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userDetailProvider);
    final state = ref.watch(addNotesProvider);
    final validation = ref.watch(validatorsProvider);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
                  'Add Note',
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
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
                textInputAction: TextInputAction.done,
                validator: (val) => validation.itineraryName(val),
                controller: noteController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: "Add your note"),
                onSaved: (val) {
                  ref.read(addNotesProvider.notifier).updateFormData(
                      userId: userId?.id ?? 0,
                      itineraryId: widget.itineraryId,
                      notes: val);
                },
                onTapOutside: (val) =>
                    FocusManager.instance.primaryFocus?.unfocus()),
          ),
          const Divider(height: 0),
          Expanded(
              child: RefreshIndicator(
            color: const Color(0xffCF5253),
            edgeOffset: 10,
            onRefresh: () async {
              ref.invalidate(getNotesProvider);
            },
            child: AsyncDataWidgetB(
              dataProvider: getNotesProvider(widget.itineraryId),
              dataBuilder: (BuildContext context, List<Notes> notes) {
                return notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("No note found!"),
                            const SizedBox(
                              height: 10,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                minimumSize: const Size(60, 40),
                              ),
                              onPressed: () {
                                ref.invalidate(getNotesProvider);
                              },
                              child: const Text(
                                "Refresh",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemBuilder: (context, index) {
                          final user = notes[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: SizedBox.square(
                                      dimension: 30,
                                      child: ImageWidget(
                                          url:
                                              "http://fernweh.acublock.in/public/${user.userImage}"),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Text(
                                      user.userName ?? "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontVariations: FVariations.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    timeAgo(user.createdAt),
                                    style: const TextStyle(
                                      color: Color(0xFF505050),
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                user.notes ?? "",
                                style: const TextStyle(
                                  color: Color(0xFF505050),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 24.0);
                        },
                        itemCount: notes.length,
                      );
              },
              loadingBuilder: Skeletonizer(
                  ignoreContainers: true,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.square(
                                    dimension: 40,
                                    child: Image.asset(
                                        "assets/images/amusement.png")),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  "dummy name",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontVariations: FVariations.w700,
                                  ),
                                ),
                              ),
                              const Text(
                                "2 minute ago",
                                style: TextStyle(
                                  color: Color(0xFF505050),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            "dummy name jhdghdjkghjdhjgdhjkghdjkhgjkdhgjfhfhjkfhjhjfhjhfjfhjhfjhjfhj",
                            style: TextStyle(
                              color: Color(0xFF505050),
                              fontSize: 12,
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 24.0);
                    },
                    itemCount: 4,
                  )),
              errorBuilder: (error, st) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(60, 40),
                      ),
                      onPressed: () {
                        ref.invalidate(getNotesProvider);
                      },
                      child: const Text(
                        "Refresh",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: AppButton(
              isLoading: state is AsyncLoading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ref.read(addNotesProvider.notifier).addNote();
                }
              },
              child: const Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}

String timeAgo(String createdAt) {
  final now = DateTime.now();
  final date = DateTime.parse(createdAt);
  final difference = now.difference(date);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}
