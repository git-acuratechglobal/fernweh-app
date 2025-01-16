import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'placeId': placeId,
      'type': type,
      'rating': rating,
      'walkingTime': walkingTime,
      'distance': distance,
      'address': address,
    };
  }

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
      name: json['name'],
      image: json['image'],
      placeId: json['placeId'],
      type: json['type'],
      rating: json['rating'],
      walkingTime: json['walkingTime'],
      distance: json['distance'],
      address: json['address'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WishList && other.placeId == placeId;
  }

  @override
  int get hashCode => placeId.hashCode;
}

final wishListProvider =
    StateNotifierProvider.autoDispose<WishListNotifier, WishListState>(
        (ref) => WishListNotifier(ref: ref));

class WishListNotifier extends StateNotifier<WishListState> {
  WishListNotifier({required this.ref})
      : super(WishListState(wishList: [], selectedItems: {})) {
    _initializeWishList();
  }

  Ref ref;

  Future<void> _initializeWishList() async {
    final wishList = ref.watch(localStorageServiceProvider).getWishList();
    if (wishList.isNotEmpty) {
      updateList(wishList);
    }
  }

  void updateList(List<WishList> wishList) {
    state = state.copyWith(data: wishList);
  }

  Future<void> addItemToWishList(WishList item) async {
    final List<WishList> updatedList = List.from(state.wishList);
    if (updatedList.contains(item)) {
      updatedList.remove(item);
    } else {
      updatedList.add(item);
    }
    state = WishListState(wishList: updatedList, selectedItems: {});
    await saveWishList(updatedList);
  }

  Future<void> saveWishList(List<WishList> wishList) async {
    await ref.read(localStorageServiceProvider).setQuickSave(wishList);
  }

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
    ref.read(localStorageServiceProvider).setQuickSave(updatedList);
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
