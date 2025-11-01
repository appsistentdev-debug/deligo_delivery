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
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/models/order_delivery_request.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/constants.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:deligo_delivery/widgets/confirm_dialog.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/custom_slider.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/my_map_widget.dart';
import 'package:deligo_delivery/widgets/order_info_widget.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class OrderInfoPage extends StatelessWidget {
  const OrderInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic argument = ModalRoute.of(context)!.settings.arguments;
    if (argument == null) Navigator.pop(context);
    return BlocProvider(
      create: (context) => FetcherCubit(),
      child: OrderInfoStateful(
        order: argument is Order ? argument : null,
        orderDeliveryRequest:
            argument is OrderDeliveryRequest ? argument : null,
      ),
    );
  }
}

class OrderInfoStateful extends StatefulWidget {
  final Order? order;
  final OrderDeliveryRequest? orderDeliveryRequest;

  const OrderInfoStateful({super.key, this.order, this.orderDeliveryRequest});

  @override
  State<OrderInfoStateful> createState() => _OrderInfoStatefulState();
}

class _OrderInfoStatefulState extends State<OrderInfoStateful> {
  late FetcherCubit _fetcherCubit;
  final GlobalKey<MyMapState> _myMapStateKey = GlobalKey();
  Order? order;
  int _distance = 0;
  int _duration = 0;
  Order get o => order ?? widget.orderDeliveryRequest!.order!;
  final GlobalKey _infoTopWidgetKey = GlobalKey();
  double _infoTopWidgetHeight = 0;
  bool _isOrderInfoOpen = false;

  @override
  void initState() {
    order = widget.order;
    _fetcherCubit = BlocProvider.of<FetcherCubit>(context);
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<FetcherCubit, FetcherState>(
          listener: (context, state) {
            if (state is UpdateDeliveryRequestLoading ||
                state is OrderLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is UpdateDeliveryRequestLoaded ||
                state is UpdateDeliveryRequestFail) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
            if (state is OrderLoaded) {
              order = state.order;
              if (state.order.delivery?.status == 'complete' ||
                  state.order.status == 'complete') {
                Navigator.pushReplacementNamed(
                    context, PageRoutes.orderCompletePage,
                    arguments: {
                      "order": o,
                      "distance": _distance,
                    });
              } else {
                setState(() {});
                if (!state.isUpdate) _actionAct();
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
        body: Stack(
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
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!_isOrderInfoOpen &&
                      (o.isOngoing || widget.orderDeliveryRequest != null))
                    CustomButton(
                      width: 150,
                      onTap: () => Helper.launchURL(
                          "http://maps.google.com/maps?saddr=${o.sourceLatLng.latitude},${o.sourceLatLng.longitude}&daddr=${o.destinationLatLng.latitude},${o.destinationLatLng.longitude}"),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      label: AppLocalization.instance
                          .getLocalizationFor("navigate"),
                      labelColor: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      bgColor: Colors.redAccent,
                      prefixIcon: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      o.user?.name ?? o.customer_name ?? "",
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: theme.hintColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          Helper.formatDistanceString(
                                            distanceInMeters:
                                                _distance.toDouble(),
                                            distanceMetric:
                                                AppSettings.distanceMetric,
                                          ),
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "(${Helper.formatDurationHm(Duration(seconds: _duration))})",
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: theme.hintColor),
                                        ),
                                        const Spacer(),
                                        if (!o.isOngoing)
                                          Text(
                                            "${AppLocalization.instance.getLocalizationFor("order")} #${o.id}",
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.hintColor),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (o.isOngoing)
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, PageRoutes.messagePage,
                                      arguments: {
                                        "chat": Chat(
                                          myId:
                                              "${o.delivery?.delivery.user?.id}${Constants.roleDriver}",
                                          chatId:
                                              "${o.user?.id}${Constants.roleUser}",
                                          chatImage: o.user?.imageUrl,
                                          chatName:
                                              o.user?.name ?? o.customer_name,
                                          chatStatus: o.user?.mobile_number ??
                                              o.customer_mobile,
                                        ),
                                        "subtitle":
                                            "${AppLocalization.instance.getLocalizationFor("orderid")} ${o.id}",
                                      }),
                                  child: CircleAvatar(
                                    backgroundColor: theme.cardColor,
                                    child: Icon(
                                      Icons.message_rounded,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              if (o.isOngoing) const SizedBox(width: 16),
                              if (o.isOngoing)
                                GestureDetector(
                                  onTap: () => Helper.launchURL(
                                      "tel:${o.user?.mobile_number ?? o.customer_mobile}"),
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
                                              "${AppLocalization.instance.getLocalizationFor("from")} ${o.vendor?.name ?? ""}",
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            Text(
                                              o.vendor?.address ??
                                                  o.source_address
                                                      ?.formatted_address ??
                                                  "",
                                              overflow: TextOverflow.visible,
                                              style: theme.textTheme.titleSmall
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
                                              "${AppLocalization.instance.getLocalizationFor("to")} ${o.user?.name ?? o.customer_name ?? ""}",
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            Text(
                                              o.address?.formatted_address ??
                                                  "",
                                              overflow: TextOverflow.visible,
                                              style: theme.textTheme.titleSmall
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
                        //const SizedBox(height: 16),
                        CustomSlider(
                          title: _actionText(),
                          onSlide: () {
                            if (widget.orderDeliveryRequest != null) {
                              _fetcherCubit.initUpdateDeliveryRequest(
                                  widget.orderDeliveryRequest!.id,
                                  widget.orderDeliveryRequest!.order?.id,
                                  "accepted",
                                  o.order_type?.toLowerCase() == "custom");
                            } else {
                              _fetcherCubit.initFetchOrder(o.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.orderDeliveryRequest != null)
              PositionedDirectional(
                top: 50,
                end: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () => ConfirmDialog.showConfirmation(
                            context,
                            Text(AppLocalization.instance
                                .getLocalizationFor("reject_order")),
                            Text(AppLocalization.instance
                                .getLocalizationFor("reject_order_msg")),
                            AppLocalization.instance.getLocalizationFor("no"),
                            AppLocalization.instance.getLocalizationFor("yes"))
                        .then((value) {
                      if (value != null && value == true) {
                        _fetcherCubit.initUpdateDeliveryRequest(
                            widget.orderDeliveryRequest!.id,
                            widget.orderDeliveryRequest!.order?.id,
                            "rejected");
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
                child: OrderInfoWidget(o, (bool isOpen) {
                  _isOrderInfoOpen = isOpen;
                  setState(() {});
                }),
              ),
          ],
        ),
      ),
    );
  }

  void _setupMarkersAndPolyline() {
    if (_myMapStateKey.currentState != null) {
      LatLng srcLatLng = o.sourceLatLng;
      LatLng dstLatLng = o.destinationLatLng;

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
        _distance = plr.totalDistance;
        _duration = plr.totalDuration;
        if (mounted) {
          setState(() {});
        }
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

  String _actionText() {
    if (widget.orderDeliveryRequest != null) {
      return AppLocalization.instance.getLocalizationFor("accept_order");
    }
    String transKey = "order_action_allotted";
    if (o.delivery?.status == "started") {
      transKey = "order_action_started";
    } else if (o.delivery?.status == "pickup") {
      transKey = "order_action_pickup";
    } else if (o.delivery?.status == "complete") {
      transKey = "order_action_complete";
    }
    return AppLocalization.instance.getLocalizationFor(transKey);
  }

  void _actionAct() {
    String? toUpdate;
    if (o.delivery?.status == "allotted") {
      toUpdate = "pickup";
    } else if (o.delivery?.status == "pickup") {
      toUpdate = "started";
    } else if (o.delivery?.status == "started") {
      toUpdate = "complete";
    }
    if (toUpdate != null) {
      if (toUpdate == "started" &&
          (o.order_type?.toLowerCase() ?? "normal") == "normal") {
        if (o.status == "dispatched" || o.status == "complete") {
          _fetcherCubit.initUpdateOrder(
              o.id, o.status == "complete" ? "complete" : "started");
        } else {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("dispatched_na"));
        }
      } else {
        _fetcherCubit.initUpdateOrder(o.id, toUpdate);
      }
    } else if (o.delivery?.status == "complete") {
      Navigator.pushReplacementNamed(context, PageRoutes.orderCompletePage,
          arguments: o);
    }
  }
}
