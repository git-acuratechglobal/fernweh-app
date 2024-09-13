import 'package:fernweh/services/api_service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/notes_model.dart';

part 'notes_notifier.g.dart';

@riverpod
FutureOr<List<Notes>> getNotes(GetNotesRef ref, int itineraryId) async {
  final notesList = await ref.watch(apiServiceProvider).getNotes(itineraryId);
  return notesList;
}

@riverpod
class AddNotes extends _$AddNotes {
  final Map<String, dynamic> _formData = {};

  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> addNote() async {
    state = const AsyncLoading<String>();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).addNote(_formData);
      ref.invalidate(getNotesProvider);
      return data;
    });
  }

  void updateFormData(
      {required int userId, required int itineraryId, String? notes}) {
    _formData["user_id"] = userId;
    _formData["itinerary_id"] = itineraryId;
    _formData["notes"] = notes;
  }
}
