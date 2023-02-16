import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// @author Appdeft
/// This class is basically a controller that control all the Order tracking data.And Helps to change order status

class TrackOrderController extends GetxController {
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
  String orderStatus = '';

  var addressTag = ''.obs;
  var shippingAddress = ''.obs;
  var deliveryTime = ''.obs;
  var orderStatusText = ''.obs;
  var orderCurrentStatus = ''.obs;

  var markers = <Marker>{}.obs;
  var polyLines = <Polyline>{}.obs;

  List<LatLng> latlng = List.empty(growable: true);

  @override
  void onInit() {
    //todo: set custom style for light and dark map
    rootBundle
        .loadString('assets/map_style_light.txt')
        .then((value) => _mapStyleLight = value);
    rootBundle
        .loadString('assets/map_style_dark.txt')
        .then((value) => _mapStyleDark = value);

    currentOrderId = Get.arguments['order_id'];
    getTrackOrderData();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      getTrackOrderData();

      /* if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }*/
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published');
      }
      getTrackOrderData();
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        Get.defaultDialog(
            title: notification.title ?? '',
            middleText: notification.body ?? '');
      }
    });

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

  //todo: Adding custom marker image
  Future<BitmapDescriptor> setCustomMarker(String iconSource) async {
    final Uint8List markerIcon =
        await Global.getBytesFromAsset(iconSource, 150);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  void setUpMarkers() async {
    log('setup markers');
    var originMarker = await setCustomMarker('assets/ic_marker_origin.png');
    _addMarker(LatLng(originLatitude.value, originLongitude.value), "origin",
        originMarker);

    var destinationMarker =
        await setCustomMarker('assets/ic_marker_destination.png');
    _addMarker(LatLng(destinationLatitude.value, destinationLongitude.value),
        "destination", destinationMarker);

    _getPolyline();
  }

  // todo: generate polyline
  void _getPolyline() async {
    PolylineResult results = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(originLatitude.value, originLongitude.value),
      PointLatLng(destinationLatitude.value, destinationLongitude.value),
      travelMode: TravelMode.driving,
    );

    log("route = ${results.status}");

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

  void getTrackOrderData() async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? '';
    var result =
        await RemoteServices.getTrackOrderDetail(token, currentOrderId);
    if (result != null) {
      if (result.success) {
        var address = result.data.deliveryAddress;
        addressTag.value = address.addressTag;
        var shippingAddressBuffer = StringBuffer();

        if (address.aditionalAddress.isNotEmpty) {
          shippingAddressBuffer.write(address.aditionalAddress);
          shippingAddressBuffer.write(', ');
        }
        if (address.address.isNotEmpty) {
          shippingAddressBuffer.write(address.address);
        }

        shippingAddress.value = shippingAddressBuffer.toString();

        deliveryTime.value = result.data.deliveryTime;
        orderStatus = result.data.status.toLowerCase();
        setOrderStatusText(orderStatus);

        try {
          double latitude = double.parse(result.data.warehouseLatitude);
          double longitude = double.parse(result.data.warehouseLongitude);

          drawMap(latitude, longitude);
        } catch (_) {}
      } else {
        Get.snackbar('Error', result.message);
      }
    }
  }

  void drawMap(double latitude, double longitude) async {
    SharedPreferences pref = await _pref;
    originLatitude.value = pref.getDouble("lat") ?? 0.0;
    originLongitude.value = pref.getDouble("lng") ?? 0.0;
    destinationLatitude.value = latitude;
    destinationLongitude.value = longitude;

    setUpMarkers();

    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(originLatitude.value, originLongitude.value),
        zoom: zoomLevel)));
  }

  //todo: setup order current status
  void setOrderStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        orderCurrentStatus.value = "confirmed";
        orderStatusText.value = 'Your order has been confirmed';
        break;

      case 'accepted':
        orderCurrentStatus.value = "accepted";
        orderStatusText.value = 'Your order is accepted now.';

        break;
      case 'shipped':
        orderCurrentStatus.value = "shipped";
        orderStatusText.value = 'Your order is on the way!';
        break;

      case 'arrived':
        orderCurrentStatus.value = "arrived";
        orderStatusText.value = 'The driver has arrived';
        break;

      case 'delivered':
        orderCurrentStatus.value = "delivered";
        orderStatusText.value = 'Your order is delivered';
        break;
    }
  }
}
