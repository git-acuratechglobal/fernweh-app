import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_places.dart';
import 'package:fernweh/view/navigation/itinerary/models/states/my_itinerary_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/itinerary_model.dart';
import '../models/states/itinerary_state.dart';

part 'itinerary_notifier.g.dart';

@Riverpod(keepAlive: true)
FutureOr<UserItinerary> getUserItinerary(GetUserItineraryRef ref) async {
  final userItinerary = await ref.watch(apiServiceProvider).getUserItinerary();
  return userItinerary;
}

@riverpod
class UserItineraryNotifier extends _$UserItineraryNotifier {
  final Map<String, dynamic> _formData = {};

  @override
  UserItineraryState build() => UserItineraryInitial();

  Future<void> createItinerary() async {
    try {
      state = UserItineraryLoading();
      final data =
          await ref.watch(apiServiceProvider).createUserItinerary(_formData);
      ref.invalidate(getUserItineraryProvider);
      state = UserItineraryCreated(itinerary: data);
    } catch (e) {
      state = UserItineraryError(error: e.toString());
    }
  }

  Future<void> updateItinerary() async {
    try {
      state = SavedLoading();
      await ref.watch(apiServiceProvider).updateItinerary(_formData);
      ref.invalidate(getUserItineraryProvider);
      state = Saved();
    } catch (e) {
      state = UserItineraryError(error: e);
    }
  }

  Future<void> deleteItinerary() async {
    try {
      state = DeleteLoading();
      await ref.watch(apiServiceProvider).deleteItinerary(_formData);
      state = Deleted();
      ref.invalidate(getUserItineraryProvider);
    } catch (e) {
      state = UserItineraryError(error: e.toString());
    }
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }
}

@riverpod
class MyItineraryNotifier extends _$MyItineraryNotifier {
  final Map<String, dynamic> _formData = {};

  @override
  MyItineraryState build() => MyItineraryInitialState();

  Future<void> createMyItinerary() async {
    try {
      state = MyItineraryLoading();
      final data =
          await ref.watch(apiServiceProvider).createMyItinerary(_formData);
      ref.invalidate(getUserItineraryProvider);
      state = MyItineraryCreatedState(myItinerary: data);
      _formData.clear();
    } catch (e) {
      state = MyItineraryErrorState(error: e);
    }
  }

  Future<void> updateMyItinerary(
      {required int id, required Map<String, dynamic> form}) async {
    try {
      state = MyItineraryLoading();
      await ref.watch(apiServiceProvider).updateMyItinerary(form, id);
      ref
          .read(itineraryPlacesNotifierProvider.notifier)
          .getTypeItineraryPlace(_formData["itinerary_id"], _formData["type"]);
      state = MyItineraryUpdatedState();
      _formData.clear();
    } catch (e) {
      state = MyItineraryErrorState(error: e);
    }
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }
}

@Riverpod(keepAlive: true)
class ItineraryPlacesNotifier extends _$ItineraryPlacesNotifier {
  @override
  FutureOr<List<ItineraryPlaces>> build() async {
    return [];
  }

  Future<void> getItineraryPlaces(int itineraryId) async {
    try {
      state = const AsyncLoading<List<ItineraryPlaces>>();
      final itineraryPlaces = await ref
          .read(apiServiceProvider)
          .getItineraryPlace(itineraryId, null);
      ref.read(itineraryLocalListProvider.notifier).loadList(itineraryPlaces);
      state = AsyncData(itineraryPlaces);
    } catch (e, st) {
      state = AsyncError<List<ItineraryPlaces>>(e, st);
    }
  }

  Future<void> getTypeItineraryPlace(int itineraryId, int? type) async {
    try {
      state = const AsyncLoading<List<ItineraryPlaces>>();
      final itineraryPlaces = await ref
          .read(apiServiceProvider)
          .getItineraryPlace(itineraryId, type);
      ref.read(itineraryLocalListProvider.notifier).loadList(itineraryPlaces);
      state = AsyncData(itineraryPlaces);
    } catch (e, st) {
      state = AsyncError<List<ItineraryPlaces>>(e, st);
    }
  }
}

final itineraryLocalListProvider =
    StateNotifierProvider.autoDispose<LocalItineraryNotifier, LocalItineraryState>(
        (ref) => LocalItineraryNotifier());

class LocalItineraryNotifier extends StateNotifier<LocalItineraryState> {
  LocalItineraryNotifier()
      : super(LocalItineraryState(itineraryPlaces: [], selectedItems: {}));

  void loadList(List<ItineraryPlaces> data) {
    state = state.copyWith(data: data);
  }

  void toggleSelection(int id) {
    final selectedItems = Set<int>.from(state.selectedItems);
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
    state = state.copyWith(selected: selectedItems);
  }

  void removeSelectedItems() {
    final updatedList = state.itineraryPlaces
        .where((item) => !state.selectedItems.contains(item.id))
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

class LocalItineraryState {
  final List<ItineraryPlaces> itineraryPlaces;
  final Set<int> selectedItems;

  LocalItineraryState(
      {required this.itineraryPlaces, required this.selectedItems});

  LocalItineraryState copyWith(
      {List<ItineraryPlaces>? data, Set<int>? selected}) {
    return LocalItineraryState(
      itineraryPlaces: data ?? itineraryPlaces,
      selectedItems: selected ?? selectedItems,
    );
  }
}




