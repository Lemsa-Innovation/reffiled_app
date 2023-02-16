import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:refilled_app/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

class LiveTrackingController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  GoogleMapController? _mapController;

//tracking order
  var originLatitude = 0.0.obs; //30.720510;
  var originLongitude = 0.0.obs; //76.721199;
  var destinationLatitude = 0.0.obs; //30.707911;
  var destinationLongitude = 0.0.obs; //76.724472;

//liveTrackingOrder
  double zoomLevel = 13.4;
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApiKey = 'AIzaSyAaVnz03Xmd1cZGKPcVcKFHg0rAX4o_BAs';
  String _mapStyleLight = "";
  String _mapStyleDark = "";
  String currentOrderId = '';

  var shippingAddress = ''.obs;
  var deliveryTime = ''.obs;
  var driverName = ''.obs;
  var driverImage = ''.obs;
  var driverPhone = '';

  var markers = <Marker>{}.obs;
  var polyLines = <Polyline>{}.obs;

  List<LatLng> latlng = List.empty(growable: true);

  @override
  void onInit() {
    rootBundle
        .loadString('assets/map_style_light.txt')
        .then((value) => _mapStyleLight = value);
    rootBundle
        .loadString('assets/map_style_dark.txt')
        .then((value) => _mapStyleDark = value);
    currentOrderId = Get.arguments['order_id'];
    _getLiveTrackingOrderData();

    super.onInit();
  }

  void onMapCreated(GoogleMapController controller, bool isLight) async {
    _mapController = controller;
    if (isLight) {
      _mapController?.setMapStyle(_mapStyleLight);
    } else {
      _mapController?.setMapStyle(_mapStyleDark);
    }
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: const InfoWindow(title: "Refilled"));
    markers.add(marker);
  }

  Future<BitmapDescriptor> setCustomMarker(String iconSource) async {
    final Uint8List markerIcon =
        await Global.getBytesFromAsset(iconSource, 150);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  void setUpMarkers() async {
    Log.verbose('setup markers');
    var originMarker = await setCustomMarker('assets/ic_marker_origin.png');
    _addMarker(LatLng(originLatitude.value, originLongitude.value), "origin",
        originMarker);

    var destinationMarker =
        await setCustomMarker('assets/ic_marker_destination.png');
    _addMarker(LatLng(destinationLatitude.value, destinationLongitude.value),
        "destination", destinationMarker);

    _getPolyline();
  }

  void _getPolyline() async {
    PolylineResult results = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(originLatitude.value, originLongitude.value),
      PointLatLng(destinationLatitude.value, destinationLongitude.value),
      travelMode: TravelMode.driving,
    );

    Log.verbose("route = ${results.status}");

    if (results.points.isNotEmpty) {
      polyLineCoordinates.clear();
      for (var point in results.points) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _addPolyline();
    }
  }

  void _addPolyline() {
    //int center = (polyLineCoordinates.length / 2).round();
    PolylineId polylineId = const PolylineId('route');
    Polyline polyline = Polyline(
        polylineId: polylineId,
        width: 3,
        color: const Color(0xFFFF5D5D),
        points: polyLineCoordinates);
    polyLines.add(polyline);
    /* _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(
            polyLineCoordinates[center].latitude,
        polyLineCoordinates[center].longitude),
        zoom: zoomLevel)
    ));*/
  }

  void _getLiveTrackingOrderData() async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? '';
    var result =
        await RemoteServices.getLiveTrackingOrderDetail(token, currentOrderId);
    if (result != null) {
      if (result.success) {
        var address = result.data.deliveryAddress;
        shippingAddress.value =
            '${address.aditionalAddress},${address.address}';

        deliveryTime.value = result.data.deliveryTime;
        driverName.value = result.data.driverName;
        driverImage.value = result.data.driverImg;
        driverPhone = result.data.driverMobile;

        try {
          originLatitude.value = double.parse(result.data.driverLatitude);
          originLongitude.value = double.parse(result.data.driverLongitude);
          destinationLatitude.value =
              double.parse(result.data.deliveryAddress.latitude);
          destinationLongitude.value =
              double.parse(result.data.deliveryAddress.longitude);
          drawMap();
        } catch (_) {}
      } else {
        Get.snackbar('Error', result.message);
      }
    }
  }

  void drawMap() async {
    setUpMarkers();

    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(originLatitude.value, originLongitude.value),
        zoom: zoomLevel)));
  }

  void callDriver() async {
    if (driverPhone.isEmpty || driverPhone == '0') {
      Get.snackbar(
          'Not available', "Driver's contact details are not available");
      return;
    } else {
      String url = 'tel:$driverPhone';
      if (await canLaunch(url)) {
        launch(url);
      } else {
        Get.snackbar('Something went wrong', "Could not able to make call");
      }
    }
  }
}
