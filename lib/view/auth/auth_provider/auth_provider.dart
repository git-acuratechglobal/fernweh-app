import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/view/auth/auth_state/auth_state.dart';
import 'package:fernweh/view/auth/signup/profile_setup/profile_step/model/intrestedin_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../services/api_service/api_service.dart';
import '../../../services/auth_service/auth_service.dart';
import '../../location_permission/location_service.dart';
import '../../navigation/itinerary/notifier/itinerary_notifier.dart';
import '../model/user_model.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class UserDetail extends _$UserDetail {
  @override
  User? build() => null;

  void update(User? Function(User? u) user) => state = user(state);
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  Map<String, dynamic> _formData = {};

  @override
  AuthState build() => Initial();

  Future<void> login() async {
    try {
      state = Loading();
      final user = await ref.watch(authServiceProvider).login(_formData);
      _formData = {};
      state = Verified(user: user);
    } catch (e) {
      state = Error(error: e);
    }
  }

  Future<void> signUp() async {
    try {
      state = Loading();
      final user = await ref.watch(authServiceProvider).signUp(_formData);
      _formData = {};
      state = SignUpVerified(user: user);
    } catch (e) {
      state = Error(error: e);
    }
  }

  Future<void> matchOtp() async {
    try {
      state = Loading();
      final user = await ref.watch(authServiceProvider).matchOtp(_formData);
      _formData = {};
      state = OtpVerified(user: user);
    } catch (e) {
      state = Error(error: e);
    }
  }

  Future<void> updateUser() async {
    final adress= await ref.watch(addressProvider.future);
    try {
      state = Loading();
      final user = await ref.watch(authServiceProvider).updateUser(_formData);
      final data = await ref
          .watch(apiServiceProvider)
          .createUserItinerary({'name': "Default list", 'type': 1,"location":adress});
      final List<String> placeId = [
        "ChIJmQJIxlVYwokRLgeuocVOGVU",
        "ChIJCewJkL2LGGAR3Qmk0vCTGkg",
        "ChIJwRSfq3btDzkRqpSJixUrNtY",
        "ChIJRRBkmSulwoARC9tR7sO6xg0",
        "ChIJbf8C1yFxdDkR3n12P4DkKt0",
        "ChIJxRO7WVEDdkgRrGM1fCYoHqY"
      ];
      for (var id in placeId) {
        ref.read(myItineraryNotifierProvider.notifier).updateForm('type', 1);
        ref
            .read(myItineraryNotifierProvider.notifier)
            .updateForm('userId', data.userId);
        ref
            .read(myItineraryNotifierProvider.notifier)
            .updateForm('intineraryListId', data.id);
        ref
            .read(myItineraryNotifierProvider.notifier)
            .updateForm('locationId', id);
        ref.read(myItineraryNotifierProvider.notifier).createMyItinerary();
      }

      if (data.id != null) {
        ref.read(localStorageServiceProvider).setItineraryId(data.id!.toInt());
      }
      _formData = {};
      state = UserUpdated(user: user);
    } catch (e) {
      _formData = {};
      state = Error(error: e);
    }
  }

  Future<void> updateProfile() async {
    try {
      state = Loading();
      final user = await ref.watch(authServiceProvider).updateUser(_formData);
      _formData = {};
      state = UserUpdated(user: user);
    } catch (e) {
      _formData = {};
      state = Error(error: e);
    }
  }

  Future<void> logOut() async {
    try {
      state = LogoutLoading();
      final token = ref.watch(localStorageServiceProvider).getToken();
      final message = await ref.watch(authServiceProvider).logOut(token ?? "");
      state = Logout(message: message);
    } catch (e) {
      state = Error(error: e);
    }
  }

  void updateFormData(String key, dynamic value) {
    _formData[key] = value;
  }
}

@Riverpod(keepAlive: true)
FutureOr<List<IntrestedInCategory>> categories(CategoriesRef ref) async {
  return await ref.watch(authServiceProvider).getCategories();
}
