import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static Future<void> setAnalyticsCollectionEnable()async {
   await _analytics.setAnalyticsCollectionEnabled(true);
  }

  /// Logs when user completes signup
  static Future<void> logUserSignupComplete({String? userId, String? method}) async {
    await _analytics.logEvent(
      name: 'user_signup_complete',
      parameters: {
        'user_id': userId!,
        'signup_method':  'email',
      },
    );
  }
  static Future<void> saveUserId({String ?userId})async{
    await _analytics.setUserId(id: userId);
  }

  /// Logs when a user creates a new collection/list
  static Future<void> logCollectionCreated({required String collectionId,required String collectionName}) async {
    await _analytics.logEvent(
      name: 'user_collection_created',
      parameters: {
        'collection_id': collectionId,
        'collection_name':collectionName
      },
    );
  }

  /// Logs when a user creates a trip
  static Future<void> logTripCreated({required String tripId, String? destination}) async {
    await _analytics.logEvent(
      name: 'user_trip_created',
      parameters: {
        'trip_id': tripId,
        if (destination != null) 'destination': destination,
      },
    );
  }

  /// Logs when home location is set
  static Future<void> logHomeLocationSet({required String location}) async {
    await _analytics.logEvent(
      name: 'home_location_set',
      parameters: {
        'location': location,
      },
    );
  }

  /// Logs when a collection is shared/collaborated
  static Future<void> logCollectionShared({
    required String collectionId,
    required String sharedWithUserId,
  }) async {
    await _analytics.logEvent(
      name: 'collection_collaborate_shared',
      parameters: {
        'collection_id': collectionId,
        'shared_with_user_id': sharedWithUserId,
      },
    );
  }
}
