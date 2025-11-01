import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/bloc/location_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/config/colors.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/chat.dart';
import 'package:deligo_delivery/models/driver_profile_update_request.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/utility/constants.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:deligo_delivery/widgets/confirm_dialog.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/custom_slider.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/my_map_widget.dart';
import 'package:deligo_delivery/widgets/ride_info_widget.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class RideInfoPage extends StatelessWidget {
  const RideInfoPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: RideInfoStateful(
            ride: ModalRoute.of(context)!.settings.arguments as Ride),
      );
}

class RideInfoStateful extends StatefulWidget {
  final Ride ride;

  const RideInfoStateful({super.key, required this.ride});

  @override
  State<RideInfoStateful> createState() => _RideInfoStatefulState();
}

class _RideInfoStatefulState extends State<RideInfoStateful> {
  late FetcherCubit _fetcherCubit;
  late Ride _ride;
  final GlobalKey<MyMapState> _myMapStateKey = GlobalKey();
  final GlobalKey _infoTopWidgetKey = GlobalKey();
  double _infoTopWidgetHeight = 0;
  bool _toastShown = false;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    _fetcherCubit = BlocProvider.of<FetcherCubit>(context);
    _ride = widget.ride;
    super.initState();
    _fetcherCubit.registerRideUpdates(_ride.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box1 =
          _infoTopWidgetKey.currentContext?.findRenderObject() as RenderBox?;
      if (box1 != null) {
        _infoTopWidgetHeight = box1.size.height;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _fetcherCubit.unRegisterRideUpdates();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<FetcherCubit, FetcherState>(
          listener: (context, state) {
            if (state is RideUpdateLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is RideUpdateLoaded) {
              if (Ride.isRidePast(state.requestStatus) || state.ride.isPast) {
                _fetcherCubit.unRegisterRideUpdates();
                if (!_toastShown) {
                  _toastShown = true;
                  Toaster.showToastCenter(AppLocalization.instance
                      .getLocalizationFor(
                          "ride_status_action_${state.requestStatus ?? state.ride.status}"));
                }
                if (state.requestStatus == "complete") {
                  Future.delayed(
                      const Duration(milliseconds: 100),
                      () => Navigator.pushReplacementNamed(
                            // ignore: use_build_context_synchronously
                            context,
                            PageRoutes.rideCompletePage,
                            arguments: state.ride,
                          ));
                } else {
                  Future.delayed(
                      const Duration(milliseconds: 100),
                      () => Navigator.popUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          (route) => route.isFirst));
                }
              } else {
                _ride = state.ride;
                setState(() {});
              }
            }
          },
        ),
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              _updateLocationOnMap(
                  LatLng(state.lattitude ?? 0, state.longitude ?? 0));
              LocalDataLayer().getSavedDriverProfile().then((driverProfile) =>
                  _fetcherCubit.initUpdateProfileMe(DriverProfileUpdateRequest(
                    current_latitude: state.lattitude,
                    current_longitude: state.longitude,
                  )));
            }
          },
        ),
      ],
      child: Scaffold(
        body: PopScope(
          canPop: false,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 150,
                child: MyMapWidget(
                  key: _myMapStateKey,
                  myMapData: MyMapData(
                    center: LatLng(AppConfig.mapCenterDefault["latitude"] ?? 0,
                        AppConfig.mapCenterDefault["longitude"] ?? 0),
                    markers: {},
                    polyLines: <Polyline>{},
                    zoomLevel: 14.0,
                    zoomControlsEnabled: false,
                  ),
                  mapStyleAsset: theme.brightness == Brightness.dark
                      ? "assets/map_style_dark.json"
                      : "assets/map_style.json",
                  onMarkerTap: (String markerId) {},
                  onMapTap: (LatLng latLng) {},
                  onBuildComplete: () => _setupMarkersAndPolyline(),
                ),
              ),
              if (_ride.isRequest)
                PositionedDirectional(
                  top: 50,
                  end: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () => ConfirmDialog.showConfirmation(
                              context,
                              Text(AppLocalization.instance
                                  .getLocalizationFor("reject_ride")),
                              Text(AppLocalization.instance
                                  .getLocalizationFor("reject_ride_msg")),
                              AppLocalization.instance.getLocalizationFor("no"),
                              AppLocalization.instance
                                  .getLocalizationFor("yes"))
                          .then((value) {
                        if (value != null && value == true) {
                          _fetcherCubit.initUpdateRide(
                              _ride.id, _ride.driver!.id, "rejected");
                        }
                      }),
                      icon: const Icon(Icons.close),
                      color: kBadgeColor,
                    ),
                  ),
                )
              else
                PositionedDirectional(
                  top: 50,
                  start: 20,
                  end: 20,
                  child: RideInfoWidget(
                    _ride,
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_ride.isOngoing || _ride.isRequest)
                      CustomButton(
                        width: 150,
                        onTap: () => Helper.launchURL(
                            "http://maps.google.com/maps?saddr=${_ride.latitude_from},${_ride.longitude_from}&daddr=${_ride.latitude_to},${_ride.longitude_to}"),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        label: AppLocalization.instance
                            .getLocalizationFor("navigate"),
                        labelColor: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        bgColor: Colors.redAccent,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: const Icon(
                            Icons.navigation_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.directions_car_filled_outlined,
                                  color: theme.primaryColor,
                                  size: 25,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _ride.user?.name ?? "",
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: theme.hintColor),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            // Helper.formatDistanceString(
                                            //   distanceInMeters:
                                            //       (_ride.estimated_distance ??
                                            //               0) *
                                            //           1000,
                                            //   distanceMetric:
                                            //       AppSettings.distanceMetric,
                                            // ),
                                            "${_ride.estimated_distance?.toStringAsFixed(1) ?? 0} km",
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "(${Helper.formatDurationHm(Duration(minutes: _ride.estimated_time?.toInt() ?? 0))})",
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: theme.hintColor),
                                          ),
                                          const Spacer(),
                                          if (!_ride.isOngoing)
                                            Text(
                                              "${AppLocalization.instance.getLocalizationFor("ride")} #${_ride.id}",
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: theme.hintColor),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (_ride.isOngoing)
                                  GestureDetector(
                                    onTap: () {
                                      _ride.setup();
                                      Navigator.pushNamed(
                                          context, PageRoutes.messagePage,
                                          arguments: {
                                            "chat": Chat(
                                              myId:
                                                  "${_ride.driver?.user?.id}${Constants.roleDriver}",
                                              chatId:
                                                  "${_ride.user?.id}${Constants.roleUser}",
                                              chatImage: _ride.user?.imageUrl,
                                              chatName: _ride.user?.name,
                                              chatStatus:
                                                  _ride.user?.mobile_number,
                                            ),
                                            "subtitle":
                                                "${AppLocalization.instance.getLocalizationFor("ride")} #${_ride.id}",
                                          });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: theme.cardColor,
                                      child: Icon(
                                        Icons.message_rounded,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                if (_ride.isOngoing) const SizedBox(width: 16),
                                if (_ride.isOngoing)
                                  GestureDetector(
                                    onTap: () => Helper.launchURL(
                                        "tel:${_ride.user?.mobile_number}"),
                                    child: CircleAvatar(
                                      backgroundColor: theme.cardColor,
                                      child: Icon(
                                        Icons.call,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            thickness: 2,
                            height: 6,
                            color: theme.colorScheme.surface,
                          ),
                          Container(
                            color: theme.scaffoldBackgroundColor,
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      key: _infoTopWidgetKey,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: CircleAvatar(
                                            radius: 11,
                                            backgroundColor: theme.primaryColor,
                                            child: Icon(
                                              Icons.location_on,
                                              size: 13,
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _ride.getMetaValue(
                                                        "name_from") ??
                                                    AppLocalization.instance
                                                        .getLocalizationFor(
                                                            "from"),
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              Text(
                                                _ride.address_from,
                                                overflow: TextOverflow.visible,
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: CircleAvatar(
                                            radius: 11,
                                            backgroundColor: theme.primaryColor,
                                            child: Icon(
                                              Icons.navigation,
                                              size: 13,
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _ride.getMetaValue("name_to") ??
                                                    AppLocalization.instance
                                                        .getLocalizationFor(
                                                            "to"),
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              Text(
                                                _ride.address_to,
                                                overflow: TextOverflow.visible,
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                PositionedDirectional(
                                  top: (_infoTopWidgetHeight + 12) / 2,
                                  start: -4,
                                  // child: Column(
                                  //   children: [
                                  //     for (int i = 0; i < 6; i++)
                                  //       Container(
                                  //         margin: EdgeInsets.only(bottom: 8),
                                  //         child: CircleAvatar(
                                  //           radius: 2,
                                  //           backgroundColor: theme.hintColor,
                                  //         ),
                                  //       ),
                                  //   ],
                                  // ),
                                  child: Icon(
                                    Icons.more_vert,
                                    color: theme.hintColor,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSlider(
                            title: AppLocalization.instance.getLocalizationFor(
                                "ride_status_action_${_ride.status}"),
                            onSlide: () {
                              switch (_ride.status) {
                                case "pending":
                                  _fetcherCubit.initUpdateRide(
                                      _ride.id, _ride.driver!.id, "accepted");
                                  break;
                                case "accepted":
                                  _fetcherCubit.initUpdateRide(
                                      _ride.id, _ride.driver!.id, "onway");
                                  break;
                                case "onway":
                                  if (_ride.getMetaValue("package_type") !=
                                      null) {
                                    _fetcherCubit.initUpdateRide(
                                        _ride.id, _ride.driver!.id, "ongoing");
                                  } else {
                                    _confirmRideOtp().then((value) {
                                      if (value != null && value == true) {
                                        _fetcherCubit.initUpdateRide(_ride.id,
                                            _ride.driver!.id, "ongoing");
                                      }
                                    });
                                  }
                                  break;
                                case "ongoing":
                                  _fetcherCubit.initUpdateRide(
                                      _ride.id, _ride.driver!.id, "complete");
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setupMarkersAndPolyline() {
    if (_myMapStateKey.currentState != null) {
      LatLng srcLatLng = LatLng(double.parse(_ride.latitude_from),
          double.parse(_ride.longitude_from));
      LatLng dstLatLng = LatLng(
          double.parse(_ride.latitude_to), double.parse(_ride.longitude_to));

      MyMapHelper.createBitmapDescriptorFromImage("assets/ic_location.png", "")
          .then((value) =>
              _myMapStateKey.currentState!.addMarker("src", value, srcLatLng));
      MyMapHelper.createBitmapDescriptorFromImage(
              "assets/ic_destination.png", "")
          .then((value) =>
              _myMapStateKey.currentState!.addMarker("dst", value, dstLatLng));

      MyMapHelper.getPolyLine(
        color: Theme.of(context).primaryColor,
        source: srcLatLng,
        destination: dstLatLng,
      ).then((MyPolylineResult plr) {
        if (_myMapStateKey.currentState?.mounted == true) {
          _myMapStateKey.currentState!.addPolyline(plr.polyline);
          Future.delayed(const Duration(milliseconds: 500),
              () => _myMapStateKey.currentState!.adjustMapZoom());
        }
      });
    }
  }

  void _updateLocationOnMap(LatLng latLng) {
    if (_myMapStateKey.currentState != null) {
      if (_myMapStateKey.currentState!.hasMarkerWithId("current_location")) {
        _myMapStateKey.currentState!
            .updateMarkerLocation("current_location", latLng);
      } else {
        MyMapHelper.createBitmapDescriptorFromImage("assets/ic_cab.png", "")
            .then(
          (bitmapDescriptor) => _myMapStateKey.currentState!
              .addMarker("current_location", bitmapDescriptor, latLng),
        );
      }
      _myMapStateKey.currentState!.moveCamera(latLng);
    }
  }

  Future<dynamic> _confirmRideOtp() {
    _otpController.clear();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalization.instance.getLocalizationFor("ride_otp")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EntryField(
              hintText:
                  AppLocalization.instance.getLocalizationFor("enter_ride_otp"),
              controller: _otpController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            textColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalization.instance.getLocalizationFor("cancel")),
          ),
          MaterialButton(
            textColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              if (_otpController.text.trim() ==
                  _ride.getMetaValue("ride_otp")) {
                Navigator.pop(context, true);
              } else {
                Toaster.showToastCenter(
                    AppLocalization.instance.getLocalizationFor("otp_invalid"));
              }
            },
            child: Text(AppLocalization.instance.getLocalizationFor("submit")),
          ),
        ],
      ),
    );
  }
}
