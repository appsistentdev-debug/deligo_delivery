import 'dart:math';
import 'dart:ui' as ui;

import 'package:deligo_delivery/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class MyMapWidget extends StatefulWidget {
  final MyMapData myMapData;
  final String? mapStyleAsset;
  final Function(String markerId) onMarkerTap;
  final Function(LatLng latLng) onMapTap;
  final Function()? onBuildComplete;

  const MyMapWidget({
    required Key key,
    required this.myMapData,
    required this.onMarkerTap,
    required this.onMapTap,
    this.mapStyleAsset,
    this.onBuildComplete,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  MyMapState createState() => MyMapState();
}

class MyMapState extends State<MyMapWidget> with AutomaticKeepAliveClientMixin {
  late MyMapData mapData;
  MarkerId? selectedMarker;
  GoogleMapController? _googleMapController;

  // ignore: unused_field, prefer_final_fields
  bool _processing = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    mapData = widget.myMapData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (kDebugMode) {
      print("BuildingMapWith: ${mapData.center}");
    }
    return FutureBuilder<String>(
      future: rootBundle.loadString(widget.mapStyleAsset != null
          ? widget.mapStyleAsset!
          : 'assets/map_style.json'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
          GoogleMap(
        initialCameraPosition: CameraPosition(
          target: mapData.center,
          zoom: mapData.zoomLevel ?? 1.0,
        ),
        // gestureRecognizers: Set()
        //   ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
        mapType: MapType.normal,
        style: snapshot.data,
        markers: Set<Marker>.of(mapData.markers.values),
        polylines: mapData.polyLines,
        zoomControlsEnabled: mapData.zoomControlsEnabled,
        onTap: (LatLng latLng) => widget.onMapTap(latLng),

        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
          // rootBundle
          //     .loadString(isDark
          //         ? 'assets/map_style_dark.json'
          //         : 'assets/map_style.json')
          //     .then((string) => _googleMapController?.setMapStyle(string));
          if (mapData.scrollX != null || mapData.scrollY != null) {
            Future.delayed(const Duration(milliseconds: 500),
                () => scrollBy(mapData.scrollX ?? 0, mapData.scrollY ?? 0));
          }
          if (widget.onBuildComplete != null) widget.onBuildComplete!.call();
        },
      ),
    );
  }

  void buildWithMyMapData(MyMapData myMapData) {
    setState(() => mapData = myMapData);
    moveCamera(mapData.center);
  }

  void moveCamera(LatLng latLng) {
    Future.delayed(
        const Duration(milliseconds: 500),
        () => _googleMapController
                ?.moveCamera(CameraUpdate.newLatLngZoom(
                    latLng, mapData.zoomLevel ?? 1.0))
                .then((value) {
              if (kDebugMode) {
                print("movedCamera");
              }
            }));
  }

  void updateMarkerIcon(String markerId, BitmapDescriptor mapPinActive,
      BitmapDescriptor mapPinInActive) {
    Marker? markerToUpdate = mapData.markers.containsKey(MarkerId(markerId))
        ? mapData.markers[MarkerId(markerId)]
        : null;
    if (markerToUpdate != null) {
      final MarkerId? previousMarkerId = selectedMarker;
      if (previousMarkerId != null &&
          mapData.markers.containsKey(previousMarkerId)) {
        final Marker resetOld = mapData.markers[previousMarkerId]!
            .copyWith(iconParam: mapPinInActive);
        mapData.markers[previousMarkerId] = resetOld;
      }

      selectedMarker = MarkerId(markerId);
      final Marker newMarker = markerToUpdate.copyWith(iconParam: mapPinActive);
      mapData.markers[selectedMarker!] = newMarker;
      setState(() {});
    }
  }

  void updateMarkerLocation(String markerId, LatLng markerLocation) {
    Marker? newMarker = mapData.markers.containsKey(MarkerId(markerId))
        ? mapData.markers[MarkerId(markerId)]!
            .copyWith(positionParam: markerLocation)
        : null;
    if (newMarker != null) {
      if (kDebugMode) {
        print("newMarker: ${newMarker.markerId.value}");
      }
      _googleMapController
          ?.animateCamera(CameraUpdate.newLatLng(markerLocation))
          .then((value) {
        setState(() {
          mapData.markers
              .removeWhere((key, value) => key == MarkerId(markerId));
          mapData.markers[MarkerId(markerId)] = newMarker;
        });
      });
    }
  }

  bool hasMarkerWithId(String markerId) =>
      mapData.markers.containsKey(MarkerId(markerId));

  // bool _listEquals(List<Marker> list1, List<Marker> list2) {
  //   bool toReturn = list1.length == list2.length;
  //   if (toReturn) {
  //     for (int i = 0; i < list1.length; i++) {
  //       if (list1[i].position != list2[i].position) {
  //         toReturn = false;
  //         break;
  //       }
  //     }
  //   }
  //   return toReturn;
  // }

  void scrollBy(double x, double y) => _googleMapController
          ?.moveCamera(CameraUpdate.scrollBy(x, y))
          .then((value) {
        if (kDebugMode) {
          print("movedCamera");
        }
      });

  void addMarker(
      String markerIdString, BitmapDescriptor markerIcon, LatLng markerLatLng) {
    final MarkerId markerId = MarkerId(markerIdString);
    mapData.markers[markerId] = Marker(
      markerId: markerId,
      icon: markerIcon,
      position: markerLatLng,
      onTap: () => widget.onMarkerTap(markerId.value),
      anchor: const Offset(0.5, 0.5),
    );
    setState(() {});
  }

  void clearMarkerWithId(String markerIdString) {
    mapData.markers.removeWhere((MarkerId markerId, Marker marker) =>
        markerId == MarkerId(markerIdString));
    setState(() {});
  }

  void addPolyline(Polyline polyLine) {
    mapData.polyLines.add(polyLine);
    setState(() {});
  }

  void clearPolyline() {
    mapData.polyLines.clear();
    setState(() {});
  }

  void adjustMapZoom() {
    if (mapData.markers.length > 1) {
      // ignore: unused_local_variable
      LatLng? latLngCenter;
      LatLngBounds? latLngBounds;
      try {
        //latLngBounds = await _googleMapController.getVisibleRegion();
        latLngBounds =
            MyMapHelper.getMarkerBounds(mapData.markers.values.toList());
        LatLng centerAll = mapData.markers.length == 1
            ? mapData.markers.values.first.position
            : LatLng(
                (latLngBounds.northeast.latitude +
                        latLngBounds.southwest.latitude) /
                    2,
                (latLngBounds.northeast.longitude +
                        latLngBounds.southwest.longitude) /
                    2,
              );
        latLngCenter = centerAll;
        //moveCamera(latLngCenter);
        _googleMapController
            ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
      } catch (e) {
        if (kDebugMode) {
          print("centerAllError: $e");
        }
      }
    }
  }
}

class MyMapData {
  final LatLng center;
  final Map<MarkerId, Marker> markers;
  final Set<Polyline> polyLines;
  final bool zoomControlsEnabled;
  final double? zoomLevel, scrollX, scrollY;

  MyMapData(
      {required this.center,
      required this.markers,
      required this.polyLines,
      required this.zoomControlsEnabled,
      this.zoomLevel,
      this.scrollX,
      this.scrollY});

  LatLng get centerLatLng => LatLng(
      double.tryParse(center.latitude.toStringAsFixed(3)) ?? 0,
      double.tryParse(center.longitude.toStringAsFixed(3)) ?? 0);

  @override
  String toString() {
    List<LatLng> latLngs = [];
    for (Marker marker in markers.values) {
      latLngs.add(marker.position);
    }
    return 'MyMapData{center: $center, markers: $latLngs, polyLines: ${polyLines.length}';
  }
}

class MyMapHelper {
  static LatLngBounds getMarkerBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  static Future<BitmapDescriptor> createBitmapDescriptorFromImage(
      String imagee, String alphabet) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = Canvas(recorder);

    double imageWidth = 70;
    double imageHeight = 70;

    // AssetBundle bundle = DefaultAssetBundle.of(context);
    ui.Image myImage = await load(imagee);
    /*await Util.getUiImage(bundle, "assets/images/image.png", imageWidth, imageHeight)*/

    paintImage(
        canvas: c, // c is the Canvas object in above code examples.
        image: myImage,
        rect: Rect.fromLTWH(0, 0, imageWidth, imageHeight * 1.1));

    TextPainter textPainter = TextPainter(
        text: TextSpan(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.w600,
            ),
            text: alphabet),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    textPainter.layout();

    textPainter.paint(c, const Offset(20, 6));

    final picture = recorder.endRecording();
    final image = await picture.toImage(110, 110);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      height: 40,
      width: 40,
    );
  }

  static Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  static Future<MyPolylineResult> getPolyLine(
      {String id = "poly",
      int width = 3,
      Color color = Colors.blue,
      required LatLng source,
      required LatLng destination}) async {
    MyPolylineCoordinatesResult myPolylineCoordinatesResult =
        await _getPolylineCoordinates(source, destination);
    return MyPolylineResult(
        Polyline(
          width: width,
          polylineId: PolylineId(id),
          color: color,
          points: myPolylineCoordinatesResult.latLngPoints,
        ),
        myPolylineCoordinatesResult.totalDistance,
        myPolylineCoordinatesResult.totalDuration);
  }

  static Future<MyPolylineCoordinatesResult> _getPolylineCoordinates(
      LatLng source, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: AppConfig.googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(source.latitude, source.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    return MyPolylineCoordinatesResult(polylineCoordinates,
        result.totalDistanceValue ?? 0, result.totalDurationValue ?? 0);
  }
}

class MyPolylineCoordinatesResult {
  final List<LatLng> latLngPoints;
  final int totalDistance;
  final int totalDuration;

  MyPolylineCoordinatesResult(
      this.latLngPoints, this.totalDistance, this.totalDuration);
}

class MyPolylineResult {
  final Polyline polyline;
  final int totalDistance;
  final int totalDuration;

  MyPolylineResult(this.polyline, this.totalDistance, this.totalDuration);
}
