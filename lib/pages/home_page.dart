import 'package:buy_this_app/buy_this_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/bloc/location_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/config/colors.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/driver_profile_update_request.dart';
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/models/order_delivery_request.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/models/ride_summary.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:deligo_delivery/widgets/confirm_dialog.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/my_map_widget.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const HomeStateful(),
      );
}

class HomeStateful extends StatefulWidget {
  const HomeStateful({super.key});

  @override
  State<HomeStateful> createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeStateful>
    implements OnlineOfflineInteractor {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MyMapState> _myMapStateKey = GlobalKey<MyMapState>();
  final GlobalKey<OnlineOfflineSwitchState> _onlineOfflineStateKey =
      GlobalKey<OnlineOfflineSwitchState>();

  late FetcherCubit _fetcherCubit;
  RideSummary? _rideSummary;
  bool _lastOnlineStatus = false;
  Ride? _rideCurrent;
  OrderDeliveryRequest? _orderDeliveryRequestCurrent;
  Order? _orderCurrent;

  @override
  void initState() {
    _fetcherCubit = BlocProvider.of<FetcherCubit>(context);
    super.initState();
    LocalDataLayer()
        .getSavedDriverProfile()
        .then((DriverProfile? driverProfile) {
      if (driverProfile != null &&
          driverProfile.current_latitude != null &&
          driverProfile.current_longitude != null) {
        _updateLocationOnMap(LatLng(
            driverProfile.current_latitude!, driverProfile.current_longitude!));
      }
      if (driverProfile != null && driverProfile.is_online == 1) {
        _fetcherCubit.initFetchCurrentRideOrRequest();
      }
    });
    if (AppConfig.isDemoMode) {
      _buyNowPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is RideSummaryLoaded) {
          _rideSummary = state.rideSummary;
          setState(() {});
        }
        if (state is RideOrRequestLoaded) {
          if (_rideCurrent == null) {
            _rideCurrent = state.ride;
            Navigator.pushNamed(context, PageRoutes.rideInfoPage,
                arguments: state.ride);
          }
        }
        if (state is OrderOrRequestLoaded &&
            state.orderDeliveryRequest != null &&
            _orderDeliveryRequestCurrent == null) {
          _orderDeliveryRequestCurrent = state.orderDeliveryRequest;
          Navigator.pushNamed(context, PageRoutes.orderInfoPage,
              arguments: state.orderDeliveryRequest);
        }
        if (state is OrderOrRequestLoaded &&
            state.order != null &&
            _orderCurrent == null) {
          _orderCurrent = state.order;
          Navigator.pushNamed(context, PageRoutes.orderInfoPage,
              arguments: state.order);
        }
      },
      builder: (context, state) => FocusDetector(
        onFocusGained: () {
          _rideCurrent = null;
          _orderCurrent = null;
          _orderDeliveryRequestCurrent = null;
          LocalDataLayer()
              .getSavedDriverProfile()
              .then((DriverProfile? driverProfile) {
            _onlineOfflineStateKey.currentState?.onSwitchChange(
                driverProfile != null && driverProfile.is_online == 1);
            if (driverProfile != null && driverProfile.is_online == 1) {
              _fetcherCubit.initFetchCurrentRideOrRequest();
            } else {
              _fetcherCubit.initFetchRideInsight("today");
            }
          });
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: const DrawerWidget(fromHome: true),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 90,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                  color: Colors.black,
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: OnlineOfflineSwitch(
              onlineOfflineInteractor: this,
              key: _onlineOfflineStateKey,
            ),
            actions: [
              // if (state is RideOrRequestLoaded)
              //   InkWell(
              //     onTap: () => Navigator.pushNamed(
              //         context, PageRoutes.rideInfoPage,
              //         arguments: state.ride),
              //     child: Container(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         color: Colors.white,
              //       ),
              //       child: Text(
              //         AppLocalization.instance.getLocalizationFor("rideInfo"),
              //         textAlign: TextAlign.center,
              //         style: theme.textTheme.labelSmall?.copyWith(
              //           color: Colors.black,
              //         ),
              //       ),
              //     ),
              //   ),
              // const SizedBox(
              //   width: 10,
              // ),
            ],
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              MyMapWidget(
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
                onBuildComplete: () {},
              ),
              if (!_lastOnlineStatus && _rideSummary != null)
                Positioned(
                  bottom: 20,
                  right: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: theme.cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            AppLocalization.instance
                                .getLocalizationFor("todaysSummary"),
                            style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 22),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _rideSummary?.ridesCount == null
                                    ? buildRow(
                                        theme,
                                        Assets.bottomMenuIcRides,
                                        AppLocalization.instance
                                            .getLocalizationFor("orders"),
                                        "${_rideSummary?.ordersCount ?? 0} ${AppLocalization.instance.getLocalizationFor("orders")}",
                                      )
                                    : buildRow(
                                        theme,
                                        Assets.bottomMenuIcRides,
                                        AppLocalization.instance
                                            .getLocalizationFor("rides"),
                                        "${_rideSummary?.ridesCount ?? 0} ${AppLocalization.instance.getLocalizationFor("trips")}",
                                      ),
                              ),
                              Expanded(
                                child: buildRow(
                                  theme,
                                  Assets.bottomMenuIcEarnings,
                                  AppLocalization.instance
                                      .getLocalizationFor("earnings"),
                                  "${AppSettings.currencyIcon} ${_rideSummary?.earnings}",
                                ),
                              ),
                              Expanded(
                                child: buildRow(
                                  theme,
                                  Assets.bottomMenuIcDistance,
                                  AppLocalization.instance
                                      .getLocalizationFor("distance"),
                                  _rideSummary!.distanceTravelledFormatted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fetcherCubit.unRegisterRideRequestUpdates();
    _fetcherCubit.unRegisterOrderRequestUpdates();
    super.dispose();
  }

  @override
  void onOnlineStatusChange(bool isOnline, LatLng? latLng) {
    LocalDataLayer()
        .getSavedDriverProfile()
        .then((driverProfile) => _fetcherCubit.initUpdateProfileMe(
              DriverProfileUpdateRequest(
                is_online: isOnline ? 1 : 0,
                current_latitude: latLng?.latitude,
                current_longitude: latLng?.longitude,
                latitude: latLng?.latitude,
                longitude: latLng?.longitude,
              ),
              markOtherOffline: true,
            ));
    if (latLng != null) {
      _updateLocationOnMap(latLng);
    }
    if (_lastOnlineStatus != isOnline) {
      _lastOnlineStatus = isOnline;
      _fetcherCubit.initFetchRideInsight("today");
      if (_lastOnlineStatus) {
        _fetcherCubit.initFetchCurrentRideOrRequest();
      } else {
        _fetcherCubit.unRegisterRideRequestUpdates();
        _fetcherCubit.unRegisterOrderRequestUpdates();
      }
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

  Column buildRow(
          ThemeData theme, String icon, String title, String subtitle) =>
      Column(
        children: [
          Image.asset(icon, height: 50, width: 50),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );

  void _buyNowPopup() =>
      LocalDataLayer().isBuyThisAppPrompted().then((isPrompted) {
        if (!isPrompted) {
          Future.delayed(const Duration(seconds: 10), () {
            if (mounted) {
              BuyThisApp.showSubscribeDialog(context);
              LocalDataLayer().setBuyThisAppPrompted();
            }
          });
        }
      });
}

class OnlineOfflineSwitch extends StatefulWidget {
  final OnlineOfflineInteractor onlineOfflineInteractor;

  const OnlineOfflineSwitch({super.key, required this.onlineOfflineInteractor});

  @override
  State<OnlineOfflineSwitch> createState() => OnlineOfflineSwitchState();
}

class OnlineOfflineSwitchState extends State<OnlineOfflineSwitch> {
  late LocationCubit _locationCubit;
  bool _isOnline = false;
  bool _isLocationLoading = false;
  bool _isLocationupdatesRegistered = false;

  @override
  void initState() {
    _locationCubit = BlocProvider.of<LocationCubit>(context);
    super.initState();
    LocalDataLayer()
        .getSavedDriverProfile()
        .then((DriverProfile? driverProfile) {
      _isOnline = (driverProfile?.is_online ?? 0) == 1;
      if (_isOnline) {
        _locationCubit.initFetchCurrentLocation(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationLoading) {
          _isLocationLoading = true;
        } else if (state is LocationFail) {
          _isOnline = false;
          widget.onlineOfflineInteractor.onOnlineStatusChange(false, null);

          if (state.msgKey == "error_permission") {
            ConfirmDialog.showConfirmation(
                    context,
                    Text(AppLocalization.instance
                        .getLocalizationFor("location_services")),
                    Text(AppLocalization.instance
                        .getLocalizationFor("location_services_msg")),
                    null,
                    AppLocalization.instance.getLocalizationFor("okay"))
                .then((value) {
              if (value != null && value == true) {
                _locationCubit.initFetchCurrentLocation(true);
              }
            });
          } else {
            Toaster.showToast(
                AppLocalization.instance.getLocalizationFor("error_service"));
          }
        } else if (state is LocationLoaded) {
          _isOnline = true;
          widget.onlineOfflineInteractor.onOnlineStatusChange(
              true, LatLng(state.lattitude ?? 0.0, state.longitude ?? 0.0));
          if (!_isLocationupdatesRegistered) {
            _locationCubit.initFetchLocationUpdates();
            _isLocationupdatesRegistered = true;
          }
        }
        _isLocationLoading = false;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${AppLocalization.instance.getLocalizationFor("youre")} ${_isOnline ? AppLocalization.instance.getLocalizationFor("online") : AppLocalization.instance.getLocalizationFor("offline")}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.primaryColorLight,
              ),
            ),
            Transform.scale(
              scale: 0.6,
              child: _isLocationLoading
                  ? Loader.circularProgressIndicatorDefault()
                  : CupertinoSwitch(
                      value: _isOnline,
                      thumbColor: _isOnline ? kPrimaryColor : kBadgeColor,
                      inactiveTrackColor: lighten(kBadgeColor, 0.3),
                      activeTrackColor: lighten(kPrimaryColor, 0.5),
                      onChanged: (val) => onSwitchChange(val),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationCubit.initStopLocationUpdates();
    super.dispose();
  }

  void onSwitchChange(bool val) {
    _isLocationLoading = val;
    _isOnline = false;
    if (val) {
      _locationCubit.initFetchCurrentLocation(true);
    } else {
      widget.onlineOfflineInteractor.onOnlineStatusChange(false, null);
      _locationCubit.initStopLocationUpdates();
      _isLocationupdatesRegistered = false;
    }
    setState(() {});
  }
}

abstract class OnlineOfflineInteractor {
  void onOnlineStatusChange(bool isOnline, LatLng? latLng);
}
