import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishList {
  final String name;
  final String image;
  final String placeId;

  WishList({required this.name, required this.image, required this.placeId});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WishList && other.placeId == placeId;
  }

  @override
  int get hashCode => placeId.hashCode;
}

final wishListProvider =
    StateNotifierProvider<WishListNotifier, List<WishList>>(
        (ref) => WishListNotifier());

class WishListNotifier extends StateNotifier<List<WishList>> {
  WishListNotifier() : super([]);

  void addItemToWishList(WishList item) {
     final data=state;
     if(data.contains(item)){
       data.remove(item);
     }else{
       data.add(item);
     }
    state = data;
  }

  void addToItinerary(WishList item){
    final data=state;
    if(!data.contains(item)){
      data.add(item);
    }
    state=data;
  }

}
