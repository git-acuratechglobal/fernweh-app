import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/friends_list/controller/friends_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/notitifier/shareItinerary_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/state/shared_itinerary_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../utils/common/extensions.dart';
import '../../../../../../utils/common/pagination_widget.dart';
import '../../../../../../utils/widgets/async_widget.dart';
import '../../../../friends_list/model/friends.dart';
import '../../../../profile/profile.dart';
import '../../../models/itinerary_model.dart';
import 'invite_friend/invite_friend_sheet.dart';

class ShareItenarySheet extends ConsumerStatefulWidget {
  const ShareItenarySheet(this.itineraryId, {super.key});

  final String? itineraryId;

  @override
  ConsumerState<ShareItenarySheet> createState() => _ShareItenarySheetState();
}

class _ShareItenarySheetState extends ConsumerState<ShareItenarySheet> {
  final List<Friends> _selectedUsers = [];
  final List<String> selectedUserId = [];
  String selectedDropdown = "view";
  final scrollController = ScrollController();

  @override
  void initState() {
    ref.listenManual(sharedItineraryProvider, (previous, next) {
      switch (next) {
        case AsyncData<SharedItineraryState?> data when data.value != null:
          if (data.value!.authEvent == SharedItineraryEvent.shared) {
            Navigator.of(context).pop();
            Common.showSnackBar(context, data.value!.message.toString());
          }
        case AsyncError error:
          Common.showSnackBar(context, error.error.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sharedItineraryState = ref.watch(sharedItineraryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
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
                'Share your Itinerary',
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
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 24.0, bottom: 12.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE2E2E2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(direction: Axis.horizontal, children: [
                    if (_selectedUsers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Add people',
                          style: TextStyle(
                            color: Color.fromARGB(255, 159, 158, 158),
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      ..._selectedUsers.map((e) {
                        final user = e;
                        return RawChip(
                          backgroundColor: const Color(0xffFFE9E9),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          deleteIcon: Icon(
                            Icons.clear,
                            size: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedUsers.remove(e);
                              selectedUserId.remove(e.id.toString());
                            });
                          },
                          label: Text(
                            user.fullName,
                            style: TextStyle(
                              fontVariations: FVariations.w500,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }),
                  ]),
                ),
                Column(
                  children: [
                    DropdownButton(
                      underline: const SizedBox.shrink(),
                      value: selectedDropdown,
                      items: const [
                        DropdownMenuItem(
                          value: "view",
                          child: Text("View Only"),
                        ),
                        DropdownMenuItem(
                          value: "edit",
                          child: Text("Edit Only"),
                        )
                      ],
                      onChanged: (v) {
                        setState(() {
                          selectedDropdown = v!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 24, bottom: 8),
          child: Text(
            'Shared with',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF1A1B28),
              fontSize: 18,
              fontVariations: FVariations.w700,
            ),
          ),
        ),
        Expanded(
            child: PaginationWidget(
          scrollController: scrollController,
          value: ref.watch(friendListProvider),
          itemBuilder: (int, user) {
            return ListTile(
              onTap: () {
                setState(() {
                  _selectedUsers.toggle(user);
                  selectedUserId.toggle(user.id.toString());
                });
              },
              leading: ClipOval(
                child: SizedBox.square(
                  dimension: 50,
                  child: user.imageUrl == null
                      ? UserInitials(name: user.fullName)
                      : ImageWidget(url: user.imageUrl.toString()),
                ),
              ),
              title: Text(
                user.fullName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontVariations: FVariations.w700,
                ),
              ),
              subtitle: Text(
                user.email.toString(),
                style: const TextStyle(
                  color: Color(0xFF505050),
                  fontSize: 14,
                ),
              ),
              trailing: IconButton(
                icon: _selectedUsers.contains(user)
                    ? Image.asset('assets/images/tick.png')
                    : Image.asset('assets/images/untick.png'),
                onPressed: () {
                  setState(() {
                    _selectedUsers.toggle(user);
                    selectedUserId.toggle(user.id.toString());
                  });
                },
              ),
            );
          },
          onLoadMore: () => ref.read(friendListProvider.notifier).loadMore(),
          separator: const SizedBox(
            height: 0,
          ),
          emptyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No friends list found"),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(60, 40),
                  ),
                  onPressed: () {
                    ref.invalidate(friendListProvider);
                  },
                  child: const Text(
                    "Refresh",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          canLoadMore: () =>
              ref.read(friendListProvider.notifier).canLoadMore(),
          loading: Skeletonizer(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final user = Config.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.image),
                  ),
                  title: Text(
                    user.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontVariations: FVariations.w700,
                    ),
                  ),
                  subtitle: Text(
                    '${user.title.replaceAll(" ", "").toLowerCase()}@mail.com',
                    style: const TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: _selectedUsers.contains(index)
                        ? Image.asset('assets/images/tick.png')
                        : Image.asset('assets/images/untick.png'),
                    onPressed: () {},
                  ),
                );
              },
              itemCount: Config.users.length,
            ),
          ),
          padding: const EdgeInsets.all(8),
        )),
        Padding(
            padding: const EdgeInsets.all(24.0),
            child: AppButton(
                isLoading: sharedItineraryState is AsyncLoading,
                onTap: () {
                  final String users = selectedUserId.join(',');
                  switch (selectedDropdown) {
                    case "view":
                      ref
                          .read(sharedItineraryProvider.notifier)
                          .updateForm("can_view", users);
                      break;
                    case "edit":
                      ref
                          .read(sharedItineraryProvider.notifier)
                          .updateForm("can_edit", users);
                      break;
                  }
                  ref
                      .read(sharedItineraryProvider.notifier)
                      .updateForm("itineraryId", widget.itineraryId.toString());
                  ref.read(sharedItineraryProvider.notifier).shareItinerary();
                },
                child: const Text("Send Invite"))),
      ],
    );
  }
}

class UnShareItenarySheet extends ConsumerStatefulWidget {
  const UnShareItenarySheet(
      {super.key, required this.viewOnly, required this.editOnly,required this.itineraryId});
final int itineraryId;
  final List<Can> editOnly;
  final List<Can> viewOnly;

  @override
  ConsumerState<UnShareItenarySheet> createState() =>
      _UnShareItenarySheetState();
}

class _UnShareItenarySheetState extends ConsumerState<UnShareItenarySheet> {
  final List<String> _canEditselectedUserId = [];
  final List<String> _canViewselectedUserId = [];
  String selectedDropdown = "view";
  final scrollController = ScrollController();

  @override
  void initState() {
    ref.listenManual(sharedItineraryProvider, (previous, next) {
      switch (next) {
        case AsyncData<SharedItineraryState?> data when data.value != null:
          if (data.value!.authEvent == SharedItineraryEvent.unShared) {
            Navigator.of(context).pop();
            Common.showSnackBar(context, data.value!.message.toString());
          }
        case AsyncError error:
          Common.showSnackBar(context, error.error.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sharedItineraryState = ref.watch(sharedItineraryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
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
                'UnShare your Itinerary',
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
          padding: const EdgeInsets.only(left: 24, top: 24, bottom: 8),
          child: Text(
            'Select friends to UnShare Itinerary',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF1A1B28),
              fontSize: 18,
              fontVariations: FVariations.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Can edit",
            style: TextStyle(
              color: const Color(0xFF1A1B28),
              fontSize: 15,
              fontVariations: FVariations.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final data = widget.editOnly[index];
              return ListTile(
                onTap: () {
                  setState(() {
                    _canEditselectedUserId.toggle(data.id.toString());
                  });
                },
                leading: ClipOval(
                  child: SizedBox.square(
                    dimension: 50,
                    child: data.imageUrl == null
                        ? UserInitials(name: data.fullName)
                        : ImageWidget(url: data.imageUrl.toString()),
                  ),
                ),
                title: Text(
                  data.fullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontVariations: FVariations.w700,
                  ),
                ),
                trailing: IconButton(
                  icon: _canEditselectedUserId.contains(data.id.toString())
                      ? Image.asset('assets/images/tick.png')
                      : Image.asset('assets/images/untick.png'),
                  onPressed: () {
                    setState(() {
                      _canEditselectedUserId.toggle(data.id.toString());
                    });
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 0);
            },
            itemCount: widget.editOnly.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Can View",
            style: TextStyle(
              color: const Color(0xFF1A1B28),
              fontSize: 15,
              fontVariations: FVariations.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final user = widget.viewOnly[index];
              return ListTile(
                onTap: () {
                  setState(() {
                    _canViewselectedUserId.toggle(user.id.toString());
                  });
                },
                leading: ClipOval(
                  child: SizedBox.square(
                    dimension: 50,
                    child: user.imageUrl == null
                        ? UserInitials(name: user.fullName)
                        : ImageWidget(url: user.imageUrl.toString()),
                  ),
                ),
                title: Text(
                  user.fullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontVariations: FVariations.w700,
                  ),
                ),
                trailing: IconButton(
                  icon: _canViewselectedUserId.contains(user.id.toString())
                      ? Image.asset('assets/images/tick.png')
                      : Image.asset('assets/images/untick.png'),
                  onPressed: () {
                    setState(() {
                      _canViewselectedUserId.toggle(user.id.toString());
                    });
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 0);
            },
            itemCount: widget.viewOnly.length,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(24.0),
            child: AppButton(
                isLoading: sharedItineraryState is AsyncLoading,
                onTap: () {
                  if (_canViewselectedUserId.isNotEmpty ||
                      _canEditselectedUserId.isNotEmpty) {
                    ref
                        .read(sharedItineraryProvider.notifier)
                        .updateForm("itineraryId", widget.itineraryId.toString());
                    if (_canEditselectedUserId.isNotEmpty) {
                      ref
                          .read(sharedItineraryProvider.notifier)
                          .updateFromList("can_edit", _canEditselectedUserId);
                    }
                    if (_canViewselectedUserId.isNotEmpty) {
                      ref
                          .read(sharedItineraryProvider.notifier)
                          .updateFromList("can_view", _canViewselectedUserId);
                    }
                    ref
                        .read(sharedItineraryProvider.notifier).unShareItinerary();
                  }
                },
                child: const Text("UnShare Itinerary"))),
      ],
    );
  }
}
