import 'package:fernweh/services/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/itinerary_model.dart';
part 'friend_list_notifier.g.dart';
@Riverpod(keepAlive:true)
FutureOr<List<Itinerary>> getFriendListItinerary(Ref ref) async {
  return await ref.watch(apiServiceProvider).getFriendListItinerary();
}
