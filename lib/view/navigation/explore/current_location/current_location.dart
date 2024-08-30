import 'package:fernweh/utils/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../utils/common/config.dart';
import '../../../../utils/common/extensions.dart';
import '../../../location_permission/location_service.dart';

class CurrentLocation extends ConsumerStatefulWidget {
  const CurrentLocation({super.key});

  @override
  ConsumerState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends ConsumerState<CurrentLocation> {
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(gradient: Config.backgroundGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.paddingOf(context).top + 8),
              child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        centerTitle: true,
                        title: Text(
                          "Enter your location name",
                          style: TextStyle(
                              fontSize: 20, fontVariations: FVariations.w700),
                        ),
                      ),
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: locationController,
                        googleAPIKey: 'AIzaSyCG4YZMnrZwDGA2sXcUF4XLQdddSL4tz5Y',
                        inputDecoration: const InputDecoration(
                          hintText: "Search your location",
                        ),
                        isCrossBtnShown: false,
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {
                          if (mounted) {
                            final position = Position(
                              longitude:
                                  double.parse(prediction.lng.toString()),
                              latitude: double.parse(prediction.lat.toString()),
                              timestamp: DateTime.now(),
                              altitude: 0.0,
                              accuracy: 0.0,
                              heading: 0.0,
                              speed: 0.0,
                              speedAccuracy: 0.0,
                              altitudeAccuracy: 0.0,
                              headingAccuracy: 0.0,
                            );
                            ref
                                .read(currentPositionProvider.notifier)
                                .updatePosition(position);
                          }
                        },
                        itemClick: (Prediction prediction) async {
                          locationController.text =
                              prediction.description ?? "";
                          locationController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: prediction.description?.length ?? 0));
                        },
                        seperatedBuilder: const Divider(),
                        itemBuilder: (context, index, Prediction prediction) {
                          return Text(prediction.description ?? "");
                        },
                      )
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: GestureDetector(
              onTap: () {
                ref.read(currentPositionProvider.notifier).currentPosition();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Image.asset('assets/images/location.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Use your current location"),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: AppButton(
              isLoading: false,
              child: const Text("Done"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    ));
  }
}
