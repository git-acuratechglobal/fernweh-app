import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/friends_list/controller/friends_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/common/common.dart';
import '../../../utils/common/config.dart';
import '../../../utils/common/pagination_widget.dart';
import 'add_friend/add_friend_screen.dart';
import 'friend_details/friend_detail_screen.dart';
import 'model/friends.dart';
import 'model/friends_state.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  final bool isBack;

  const FriendsScreen({super.key, this.isBack = false});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final searchFriend = FocusNode();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(gradient: Config.backgroundGradient),
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 20,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: widget.isBack
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : null,
                actions: const [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           padding: const EdgeInsets.symmetric(horizontal: 10),
                  //           minimumSize: const Size(60, 40)),
                  //       onPressed: () {
                  //         Navigator.of(context).push(
                  //           MaterialPageRoute(
                  //             fullscreenDialog: true,
                  //             builder: (context) => const AddFriendScreen(),
                  //           ),
                  //         );
                  //       },
                  //       child: const Text('Suggestions')),
                  // )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 50,
                        //     width: 300,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       border: Border.all(color: Colors.grey),
                        //       color: Colors.white,
                        //     ),
                        //     child: const Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 20),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             "Search friends",
                        //             style: TextStyle(fontSize: 15),
                        //           ),
                        //           Icon(Icons.search),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: TextFormField(
                            focusNode: searchFriend,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: "Search friends",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffE2E2E2)),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffCF5253), width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onTapOutside: (val) {
                              searchFriend.unfocus();
                            },
                            onChanged: (val) {
                              ref
                                  .read(friendListProvider.notifier)
                                  .search(search: val);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => const AddFriendScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_circle,
                            size: 30,
                          ),
                        )
                      ])),
              TabBar(
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 40),
                  labelColor: Theme.of(context).colorScheme.secondary,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  dividerColor: const Color(0xffE2E2E2),
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelStyle: TextStyle(
                    fontFamily: "Plus Jakarta Sans",
                    fontSize: 15,
                    fontVariations: FVariations.w500,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: "Plus Jakarta Sans",
                    fontSize: 15,
                    fontVariations: FVariations.w700,
                  ),
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: 'Friends List',
                    ),
                    Tab(
                      text: 'Friend Requests',
                    )
                  ]),
              Expanded(
                child: TabBarView(controller: tabController, children: <Widget>[
                  RefreshIndicator(
                      color: const Color(0xffCF5253),
                      onRefresh: () async {
                        ref.invalidate(friendListProvider);
                      },
                      child: const FriendsList()),
                  RefreshIndicator(
                      color: const Color(0xffCF5253),
                      onRefresh: () async {
                        ref.invalidate(friendRequestProvider);
                      },
                      child: const FriendRequests())
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FriendsList extends ConsumerStatefulWidget {
  const FriendsList({super.key});

  @override
  ConsumerState<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PaginationWidget(
      retry: () => ref.refresh(friendListProvider),
      scrollController: scrollController,
      value: ref.watch(friendListProvider),
      itemBuilder: (int, user) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FriendDetailScreen(
                  friends: user,
                ),
              ),
            );
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
                          url:
                              'http://fernweh.acublock.in/public/${user.image}')),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.fade,
                        user.name ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontVariations: FVariations.w700,
                        ),
                      ),
                    ),
                    const Text(
                      '5 Itinerary',
                      style: TextStyle(
                        color: Color(0xFF505050),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      onLoadMore: () => ref.read(friendListProvider.notifier).loadMore(),
      separator: const SizedBox(
        height: 10,
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
      canLoadMore: () => ref.read(friendListProvider.notifier).canLoadMore(),
      padding: const EdgeInsets.all(24),
      loading: Skeletonizer(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
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
                  const ClipOval(
                    child: SizedBox.square(
                        dimension: 50,
                        child: ImageWidget(
                            url: 'http://fernweh.acublock.in/public/')),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "dummy name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontVariations: FVariations.w700,
                        ),
                      ),
                      const Text(
                        '5 Itinerary',
                        style: TextStyle(
                          color: Color(0xFF505050),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FriendRequests extends ConsumerStatefulWidget {
  const FriendRequests({super.key});

  @override
  ConsumerState<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends ConsumerState<FriendRequests> {
  final List<String> userIds = [];
  final List<String> acceptedRequests = [];

  @override
  void initState() {
    ref.listenManual(friendsNotifierProvider, (previous, next) {
      switch (next) {
        case AsyncData<FriendsState?> data when data.value != null:
          if (data.value!.friendsEvent == FriendsEvent.requestAccept) {
            setState(() {
              acceptedRequests.add(data.value!.response.toString());
              userIds.remove(data.value!.response);
            });
            Common.showSnackBar(context, "Request accept successfully");
            userIds.clear();
          }

        case AsyncError error:
          Common.showSnackBar(context, error.error.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncDataWidgetB(
        dataProvider: friendRequestProvider,
        dataBuilder: (BuildContext context, List<Friends> friends) {
          return friends.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No friend request found"),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(60, 40),
                        ),
                        onPressed: () {
                          ref.invalidate(friendRequestProvider);
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    print(friends[index].id);
                    final user = friends[index];
                    bool isSelected =
                        acceptedRequests.contains(user.id.toString());
                    return InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => FriendDetailScreen(user),
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
                                    url:
                                        'http://fernweh.acublock.in/public/${user.image}',
                                  )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      user.name ?? "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontVariations: FVariations.w700,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '5 Itinerary',
                                    style: TextStyle(
                                      color: Color(0xFF505050),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isSelected
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      minimumSize: const Size(60, 40),
                                    ),
                                    onPressed: () {
                                      // setState(() {
                                      //   widget.isSelected = ! widget.isSelected;
                                      // });
                                    },
                                    child: const Text(
                                      "Accepted",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                                : Expanded(

                                  child: AppButton(
                                      isLoading:
                                          userIds.contains(user.id.toString()),
                                      onTap: () {
                                        setState(() {
                                          userIds.add(user.id.toString());
                                        });
                                        ref
                                            .read(
                                                friendsNotifierProvider.notifier)
                                            .acceptRequest(user.id ?? 0,);
                                      },
                                      size: const Size(60, 40),
                                      child: const Text("Accept"),
                                    ),
                                ),

                            // SizedBox(
                            //   width: 100,
                            //   child: AppButton(
                            //     isLoading: false,
                            //     onTap: () {},
                            //     size: const Size(60, 40),
                            //     child: const Text("Decline"),),
                            // )
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
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
                      ref.invalidate(friendRequestProvider);
                    },
                    child: const Text(
                      "Refresh",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
        loadingBuilder: Skeletonizer(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: 10,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => FriendDetailScreen(user),
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
                      const ClipOval(
                        child: SizedBox.square(
                            dimension: 50,
                            child: ImageWidget(
                              url: "",
                            )),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "dummmy",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontVariations: FVariations.w700,
                            ),
                          ),
                          const Text(
                            '5 Itinerary',
                            style: TextStyle(
                              color: Color(0xFF505050),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
