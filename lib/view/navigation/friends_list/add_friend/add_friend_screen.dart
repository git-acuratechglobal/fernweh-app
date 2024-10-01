import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/common/extensions.dart';
import '../../itinerary/widgets/my_curated_list/share_your_itinerary/invite_friend/invite_friend_sheet.dart';
import '../controller/friends_notifier.dart';
import '../model/friends.dart';
import '../model/friends_state.dart';

class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  List<String> friendId = [];
  final _textFieldFocusNode = FocusNode();
  List<int> usesrId = [];
  Map<int, bool> isLoading = {};

  @override
  void initState() {
    ref.listenManual(friendsNotifierProvider, (previous, next) {
      switch (next) {
        case AsyncData<FriendsState?> data when data.value != null:
          if (data.value!.friendsEvent == FriendsEvent.requestSent) {
            setState(() {
              friendId.add(data.value!.response ?? "");
              usesrId.map((e) => isLoading[e] = false).toList();
            });
            Common.showSnackBar(context, "Request sent successfully");
          }
        case AsyncError error:
          setState(() {
            usesrId.map((e) => isLoading[e] = false).toList();
          });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                focusNode: _textFieldFocusNode,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    hintText: "Search friends",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        borderSide: const BorderSide(
                            color: Color(0xffCF5253), width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2)),
                    suffixIcon: const Icon(Icons.search)),
                onFieldSubmitted: (val) {
                  ref.read(searchFriendProvider.notifier).searchFriends(val);
                },
                onChanged: (val) {
                  ref.read(searchFriendProvider.notifier).searchFriends(val);
                },
                onTapOutside: (val) {
                  _textFieldFocusNode.unfocus();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    constraints: BoxConstraints.tightFor(
                      height: MediaQuery.sizeOf(context).height * 0.65,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return const InviteFriendSheet();
                    },
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/user-add.png',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Invite Friend",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: AsyncDataWidgetB(
              dataProvider: searchFriendProvider,
              dataBuilder: (BuildContext context, friends) {
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: friends!.length,
                  itemBuilder: (context, index) {
                    final users = friends[index];
                    bool isSelected = friendId.contains(users.id.toString());
                    return FriendListItem(
                      isloading: isLoading[users.id] == true,
                      user: users,
                      isSelected: isSelected,
                      addFriend: () {
                        setState(() {
                          isLoading[users.id ?? 0] = true;
                          usesrId.add(users.id ?? 0);
                        });
                        ref
                            .read(friendsNotifierProvider.notifier)
                            .sendRequest(users.id ?? 0, 1);
                      },
                    );
                  },
                );
              },
              errorBuilder: (error, stacktrace) => Center(
                child: Text(error.toString()),
              ),
              loadingBuilder: Skeletonizer(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return FriendListItem(
                      user: Friends(
                          id: null,
                          name: 'dummy',
                          email: '',
                          image: null,
                          gender: '',
                          dob: null,
                          fcmToken: '',
                          phone: '',
                          userRole: null,
                          status: null,
                          isDeleted: null,
                          emailVerifiedAt: null,
                          createdAt: null,
                          updatedAt: null),
                      isSelected: false,
                      addFriend: () {},
                      isloading: false,
                    );
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class FriendListItem extends StatefulWidget {
  const FriendListItem({
    super.key,
    required this.user,
    required this.isSelected,
    required this.isloading,
    required this.addFriend,
  });

  final bool isSelected;
  final bool isloading;

  final Friends user;
  final Function() addFriend;

  @override
  State<FriendListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  bool addFriend = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         FriendDetailScreen(widget.user, isAddFriend: true),
        //   ),
        // );
      },
      child: Container(
        width: double.infinity,
        height: 85,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffE2E2E2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox.square(
                  dimension: 50,
                  child: ImageWidget(
                    url: widget.user.imageUrl,
                  )),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.fade,
                      widget.user.fullName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                  ),
                  const Text(
                    '5 Iternerary',
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                ],
              ),
            ),
            AddRequestButton(
              isLoading: widget.isloading,
              user: widget.user,
              isSelected: widget.isSelected,
              addRequest: widget.addFriend,
            )
          ],
        ),
      ),
    );
  }
}

class AddRequestButton extends ConsumerStatefulWidget {
  final Size? size;
  final Friends user;
  final bool isLoading;
  final void Function() addRequest;

  AddRequestButton(
      {super.key,
      this.size,
      required this.user,
      required this.isSelected,
      required this.addRequest,
      required this.isLoading});

  bool isSelected;

  @override
  ConsumerState<AddRequestButton> createState() => _AddRequestButtonState();
}

class _AddRequestButtonState extends ConsumerState<AddRequestButton> {
  bool addFriend = false;
  bool isLoading = false;

  // @override
  // void initState() {
  //   if (widget.isSelected) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: widget.size ?? const Size(60, 40),
        ),
        onPressed: () {
          // setState(() {
          //   widget.isSelected = ! widget.isSelected;
          // });
        },
        child: const Text(
          "Requested",
          style: TextStyle(fontSize: 14),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: AppButton(
          size: const Size(60, 40),
          isLoading: widget.isLoading,
          child: const Text("Add Friend", style: TextStyle(fontSize: 14)),
          onTap: widget.addRequest,
          // onTap: () {
          //   setState(() {
          //     isLoading = true;
          //   });
          //   ref
          //       .read(friendsNotifierProvider.notifier)
          //       .sendRequest(widget.user.id ?? 0, 1);
          // },
        ),
      );
    }
  }
}
