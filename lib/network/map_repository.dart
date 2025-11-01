import 'package:flutter/foundation.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:deligo_delivery/config/app_config.dart';

class MapRepository {
  Future<Placemark> getPlaceMarkFromLatLng(LatLng latLng) async {
    List<Placemark> p =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = p[0];
    return place;
  }

  Future<String> getAddress(LatLng latLng, bool full) async {
    Placemark place = await getPlaceMarkFromLatLng(latLng);
    if (kDebugMode) {
      print("Address For: ${place.toJson()}");
    }
    String currentAddress = "";
    List<String> addressComponents = [];
    if (place.name != null && place.name!.isNotEmpty) {
      addressComponents.add(place.name!);
    }
    if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
      addressComponents.add(place.subThoroughfare!);
    }
    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      addressComponents.add(place.thoroughfare!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressComponents.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressComponents.add(place.locality!);
    }
    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      addressComponents.add(place.subAdministrativeArea!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressComponents.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressComponents.add(place.postalCode!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressComponents.add(place.country!);
    }
    addressComponents = [
      ...{...addressComponents}
    ];
    if (addressComponents.isNotEmpty) {
      currentAddress = full
          ? addressComponents.join(", ")
          : (double.tryParse(addressComponents[0]) == null
              ? addressComponents[0]
              : addressComponents[1]);
    }
    return currentAddress;
  }

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    PlacesDetailsResponse response =
        await GoogleMapsPlaces(apiKey: AppConfig.googleApiKey)
            .getDetailsByPlaceId(placeId);
    if (kDebugMode) {
      print("getPlaceDetails: ${response.status}");
      print("getPlaceDetails: ${response.errorMessage}");
    }
    return response.result;
  }
}
