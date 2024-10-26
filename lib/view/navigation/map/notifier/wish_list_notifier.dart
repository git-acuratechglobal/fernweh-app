import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishList {
  final String name;
  final String image;
  final String placeId;
  final String type;
  final String rating;
  final String walkingTime;
  final String distance;
  final String address;

  WishList(
      {required this.name,
      required this.image,
      required this.placeId,
      required this.address,
      required this.type,
      required this.rating,
      required this.walkingTime,
      required this.distance});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WishList && other.placeId == placeId;
  }

  @override
  int get hashCode => placeId.hashCode;
}

final wishListProvider = StateNotifierProvider.autoDispose<WishListNotifier, WishListState>(
    (ref) => WishListNotifier());

class WishListNotifier extends StateNotifier<WishListState> {
  WishListNotifier() : super(WishListState(wishList: [], selectedItems: {}));

  void addItemToWishList(WishList item) {
    final List<WishList> updatedList = List.from(state.wishList);
    if (updatedList.contains(item)) {
      updatedList.remove(item);
    } else {
      updatedList.add(item);
    }
    state = WishListState(wishList: updatedList, selectedItems: {});
  }

  // void addToItinerary(WishList item) {
  //   final data = state;
  //   if (!data.contains(item)) {
  //     data.add(item);
  //   }
  //   state = data;
  // }

  void toggleSelection(String id) {
    final selectedItems = Set<String>.from(state.selectedItems);
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
    state = state.copyWith(selected: selectedItems);
  }

  void removeSelectedItems() {
    final updatedList = state.wishList
        .where((item) => !state.selectedItems.contains(item.placeId))
        .toList();

    state = state.copyWith(
      data: updatedList,
      selected: {},
    );
  }
  void clearSelection() {
    state = state.copyWith(selected: {});
  }
}

class WishListState {
  final List<WishList> wishList;
  final Set<String> selectedItems;

  WishListState({required this.wishList, required this.selectedItems});

  WishListState copyWith({List<WishList>? data, Set<String>? selected}) {
    return WishListState(
      wishList: data ?? wishList,
      selectedItems: selected ?? selectedItems,
    );
  }
}
