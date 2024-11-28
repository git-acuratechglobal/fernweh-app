import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/friends_list/controller/follow_friend_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/common/extensions.dart';
import '../../itinerary/widgets/my_curated_list/share_your_itinerary/invite_friend/invite_friend_sheet.dart';
import '../../profile/profile.dart';
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
  List<int> followed = [];
  List<int> followList = [];

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
    ref.listenManual(followFriendProvider, (previous, next) {
      switch (next) {
        case AsyncData<FollowFriendState?> data when data.value != null:
          setState(() {
            followed.remove(data.value?.id);
            if (data.value?.message == "User Unfollowed!") {
              followList.remove(data.value?.id ?? 0);
            } else {
              followList.add(data.value?.id ?? 0);
            }
          });
        case AsyncError error:
          print(error);

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
              dataBuilder: (friends) {
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: friends!.length,
                  itemBuilder: (context, index) {
                    final users = friends[index];
                    bool isSelected = friendId.contains(users.id.toString());
                    bool followPressed = followed.contains(users.id);
                    bool isFollowing = users.userFollowed == "Yes" ||
                        followList.contains(users.id);
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
                      isFollowing: isFollowing,
                      followFriend: () {
                        setState(() {
                          followed.add(users.id ?? 0);
                        });
                        ref
                            .read(followFriendProvider.notifier)
                            .followFriend(users.id ?? 0);
                      },
                      followLoading: followPressed,
                    );
                  },
                );
              },
              errorBuilder: (error, stacktrace) => Center(
                child: Text(error.toString()),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class FriendListItem extends ConsumerStatefulWidget {
  const FriendListItem({
    super.key,
    required this.user,
    required this.isSelected,
    required this.isloading,
    required this.addFriend,
    required this.isFollowing,
    required this.followLoading,
    required this.followFriend,
  });

  final bool isSelected;
  final bool isloading;
  final bool isFollowing;
  final bool followLoading;
  final Friends user;
  final Function() addFriend;
  final Function() followFriend;

  @override
  ConsumerState<FriendListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends ConsumerState<FriendListItem> {
  bool addFriend = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 85,
      padding: const EdgeInsets.all(10),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipOval(
            child: SizedBox.square(
                dimension: 40,
                child: widget.user.imageUrl == null
                    ? UserInitials(name: widget.user.fullName)
                    : ImageWidget(url: widget.user.imageUrl.toString())),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 80,
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              widget.user.fullName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontVariations: FVariations.w700,
              ),
            ),
          ),
          CustomButton(
              isFollow: widget.isFollowing,
              fixedSize: const Size(80, 40),
              isLoading: widget.followLoading,
              onTap: widget.followFriend,
              child: Text(
                widget.isFollowing ? "Following" : "Follow",
                style: TextStyle(
                    fontSize: 12,
                    color: widget.isFollowing ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w900),
              )),
          const SizedBox(
            width: 5,
          ),
          AddRequestButton(
            isLoading: widget.isloading,
            user: widget.user,
            isSelected: widget.isSelected,
            addRequest: widget.addFriend,
          )
        ],
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
          style: TextStyle(fontSize: 12),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: CustomButton(
          size: const Size(80, 40),
          isLoading: widget.isLoading,
          onTap: widget.addRequest,
          child: const Text(
            textAlign: TextAlign.center,
            "Add Friend",
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w900),
          ),
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

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.isLoading,
      this.onTap,
      required this.child,
      this.size,
      this.fixedSize,
      this.isFollow = false});

  final Size? size;
  final Widget child;
  final bool isLoading;
  final Function()? onTap;
  final Size? fixedSize;
  final bool isFollow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: fixedSize?.width ?? size?.width,
        height: fixedSize?.height ?? size?.height,
        decoration: BoxDecoration(
            color: isLoading
                ? Colors.grey.shade300
                : (isFollow ? Colors.white : const Color(0xff1A72FF)),
            borderRadius: BorderRadius.circular(8),
            border:isFollow? Border.all(color: Colors.grey):null),
        alignment: Alignment.center,
        child: isLoading
            ? LoadingAnimationWidget.twistingDots(
                size: 30,
                leftDotColor: const Color(0xFFCF5253),
                rightDotColor: const Color(0xff1A72FF),
              )
            : child,
      ),
    );
  }
}
