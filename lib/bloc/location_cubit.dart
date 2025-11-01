import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:deligo_delivery/models/my_location.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:deligo_delivery/utility/location_helper.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  StreamSubscription? _locationSubscription;
  // ignore: avoid_init_to_null
  LocationLoaded? debugLocation =
      null; //LocationLoaded(28.6207887, 77.4278999);

  LocationCubit() : super(const LocationInitial());

  void initFetchLocationUpdates() async {
    _locationSubscription?.cancel();
    _locationSubscription =
        LocationHelper.getPositionStream().listen((locationData) async {
      if (debugLocation != null) {
        await Future.delayed(const Duration(seconds: 1));
        emit(debugLocation!);
        return;
      }
      if (state is LocationLoaded) {
        var currentState = state as LocationLoaded;
        if (locationData.latitude != currentState.lattitude &&
            locationData.longitude != currentState.longitude) {
          LocalDataLayer().setSavedLocation(
              MyLocation(locationData.latitude, locationData.longitude));
          emit(LocationLoaded(locationData.latitude, locationData.longitude));
        }
      }
    });
  }

  void initStopLocationUpdates() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void initFetchCurrentLocation(bool freshLocation) async {
    emit(const LocationLoading());
    if (debugLocation != null) {
      await Future.delayed(const Duration(seconds: 1));
      emit(debugLocation!);
      return;
    }
    MyLocation? savedLocation;
    if (!freshLocation) {
      savedLocation = await LocalDataLayer().getSavedLocation();
      if (savedLocation != null) {
        emit(LocationLoaded(savedLocation.lattitude, savedLocation.longitude));
      }
    }
    try {
      Position position = await LocationHelper.getPosition();
      LocalDataLayer()
          .setSavedLocation(MyLocation(position.latitude, position.longitude));
      if (freshLocation || savedLocation == null) {
        emit(LocationLoaded(position.latitude, position.longitude));
      }
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        if (freshLocation || savedLocation == null) {
          emit(const LocationFail("error_service"));
        }
      } else if (e is PermissionDeniedException) {
        if (freshLocation || savedLocation == null) {
          emit(const LocationFail("error_permission"));
        }
      }
    }
  }
}
