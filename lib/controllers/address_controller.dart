import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refilled_app/controllers/checkout_controller.dart';
import 'package:refilled_app/data/model/my_address_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:refilled_app/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressController extends GetxController {
  var addresses = <MyAddressData>[].obs;

  var showProgress = false.obs;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final CheckoutController _checkoutController = Get.put(CheckoutController());
  late final SlidableController slidableController;
  int clickedIndex = -1;
  final addressTagController = TextEditingController();
  final additionalAddressController = TextEditingController();
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  late BitmapDescriptor mapMarker;
  var address = "".obs;
  var addressName = "".obs;
  var currentPosition = const LatLng(0.0, 0.0).obs;
  Map? editAddressData;
  int? addressId;
  bool isEditAddress = false;
  bool isHavingLocationPermission = false;
  bool isPickingAddress = false;
  double zoomLevel = 19.4746;

  @override
  void onInit() {
    fetchMyAddressList();
    slidableController = SlidableController();
    _setCustomMarker();

    initCurrentPosition();
    super.onInit();
  }

  void initCurrentPosition() async {
    isEditAddress = false;
    SharedPreferences pref = await _pref;
    var lat = pref.getDouble("lat") ?? 0.0;
    var lng = pref.getDouble("lng") ?? 0.0;
    currentPosition.value = LatLng(lat, lng);
    additionalAddressController.text = "";
    addressTagController.text = "";
    address.value = await Global.getAddress(lat, lng);
    addressName.value = await Global.getAddressName(lat, lng);
    _addMarker();
  }

  Future<void> fetchMyAddressList() async {
    if (addresses.isNotEmpty) addresses.clear();
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? "";
    var result = await RemoteServices.fetchMyAddressList(token);

    if (result != null) {
      if (result.success) {
        addresses.addAll(result.data ?? List.empty());
      } else {
        Get.snackbar("Error", result.message);
        addresses.addAll(List.empty());
      }
    } else {
      addresses.addAll(List.empty());
    }

    showProgress.value = false;
  }

  void _addMarker() {
    markers.clear();
    markers.add(Marker(
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('id-1'),
        position: currentPosition.value,
        infoWindow: const InfoWindow(
            title: 'Your order deliver here...',
            snippet: 'Drag marker to pick location'),
        onDragEnd: ((newPosition) {
          currentPosition.value =
              LatLng(newPosition.latitude, newPosition.longitude);

          _addMarker();

          _mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: currentPosition.value,
            zoom: zoomLevel,
          )));
          getCurrentPositionAddress();
        })));
  }

  String getUserAddress(int position) {
    String additionalAddress = addresses[position].aditionalAddress;
    String address = addresses[position].address;
    StringBuffer result = StringBuffer();
    if (additionalAddress.isNotEmpty) {
      result.write(additionalAddress);
      result.write(", ");
    }
    result.write(address);

    return result.toString();
  }

  Future<void> deleteAddress(int position) async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? "";

    var result =
        await RemoteServices.deleteAddress(token, addresses[position].id);

    if (result != null) {
      if (result.success) {
        if (_checkoutController.addressId.value ==
            addresses[position].id.toString()) {
          addresses.removeAt(position);
          Log.verbose("remove from position");

          _checkoutController.fetchMyAddressList();
        } else {
          addresses.removeAt(position);
        }

        Get.snackbar('Success', result.message);
        if (addresses.isEmpty) {}
      } else {
        Get.snackbar('Error', result.message);
      }
    }
    showProgress.value = false;
  }

  Future<bool> checkIfLocationServiceEnabled() async {
    var serviceEnabled =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.defaultDialog(
        title: "GPS Disbaled",
        titleStyle: const TextStyle(
            color: Color(0xFF061737),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 16),
        middleText:
            "we require your location to show you product near by you please enable your gps to help us",
        middleTextStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
            fontSize: 14),
      );
      return false;
    }
    return true;
  }

  Future<bool> checkForLocationPermission() async {
    if (await Permission.locationWhenInUse.isGranted) {
      return await checkIfLocationServiceEnabled();
    } else {
      var isGranted = await Permission.locationWhenInUse.request().isGranted;
      if (isGranted) {
        return await checkIfLocationServiceEnabled();
      } else {
        Get.defaultDialog(
          title: "Permission Denied",
          titleStyle: const TextStyle(
              color: Color(0xFF061737),
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              fontSize: 16),
          middleText:
              "Location permission required to access your current location",
          middleTextStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              fontSize: 14),
        );
        return false;
      }
    }
  }

  void _setCustomMarker() async {
    final Uint8List markerIcon =
        await Global.getBytesFromAsset('assets/ic_location_marker.png', 150);
    mapMarker = BitmapDescriptor.fromBytes(markerIcon);
  }

  void searchAddress() async {
    dynamic result = await Get.toNamed('/search_place');

    currentPosition.value = LatLng(result['lat'], result['lng']);
    address.value = await Global.getAddress(
        currentPosition.value.latitude, currentPosition.value.longitude);
    addressName.value = await Global.getAddressName(
        currentPosition.value.latitude, currentPosition.value.longitude);

    Log.verbose("setting new state");
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currentPosition.value,
      zoom: zoomLevel,
    )));

    _addMarker();
  }

  void getCurrentPositionAddress() async {
    address.value = await Global.getAddress(
        currentPosition.value.latitude, currentPosition.value.longitude);
    addressName.value = await Global.getAddressName(
        currentPosition.value.latitude, currentPosition.value.longitude);
  }

  void getCurrentLocation() async {
    var isHavingLocationPermission = await checkForLocationPermission();

    if (isHavingLocationPermission) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition.value = LatLng(position.latitude, position.longitude);

      address.value = await Global.getAddress(
          currentPosition.value.latitude, currentPosition.value.longitude);
      addressName.value = await Global.getAddressName(
          currentPosition.value.latitude, currentPosition.value.longitude);

      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: currentPosition.value,
        //  zoom: 12.4746,
        zoom: zoomLevel,
      )));

      _addMarker();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currentPosition.value,
      zoom: zoomLevel,
    )));

    _addMarker();
  }

  void validateAndAddAddress() async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? "";
    var addressTag = addressTagController.text;
    var additionalAddress = additionalAddressController.text;
    var lat = currentPosition.value.latitude;
    var lng = currentPosition.value.longitude;

    if (token.isEmpty) {
      Log.verbose("add address screen token is empty");
      return;
    }

    /*  if (additionalAddress.isEmpty) {
      Get.snackbar(
          "Required", "Please add some additional infomation for this address");
      return;
    }

    if (addressTag.isEmpty) {
      Get.snackbar("Required", "Please add a Tag for this address");
      return;
    }*/

    if (lat == 0 || lng == 0) {
      Get.snackbar("Required", "Please pick a location for this address");
      return;
    }

    showProgress(true);
    var result = await RemoteServices.addAddress(
        token, addressTag, address.value, additionalAddress, lat, lng);
    showProgress(false);

    if (result != null) {
      if (result.success) {
        await fetchMyAddressList();

        Log.verbose(
            'is picking address  =$isPickingAddress   ====   addresses length = ${addresses.length}');

        if (isPickingAddress && addresses.length == 1) {
          _checkoutController.fetchMyAddressList();
        }

        Get.back();
        Get.snackbar('Success', result.message);
        return;
      } else {
        Get.snackbar('Error', result.message);
      }
    } else {}
  }

  void editAddress(int position) {
    isEditAddress = true;
    try {
      MyAddressData myAddress = addresses[position];
      currentPosition.value = LatLng(
          double.parse(myAddress.latitude), double.parse(myAddress.longitude));
      address.value = myAddress.address;
      additionalAddressController.text = myAddress.aditionalAddress;
      addressTagController.text = myAddress.addressTag;
      addressId = myAddress.id;
      Get.toNamed('add_address');
    } catch (_) {}
  }

  void validateAndUpdateAddress() async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? "";
    var addressTag = addressTagController.text;
    var additionalAddress = additionalAddressController.text;
    var lat = currentPosition.value.latitude;
    var lng = currentPosition.value.longitude;

    if (token.isEmpty) {
      Log.debug("add address screen token is empty");
      return;
    }

    /* if (additionalAddress.isEmpty) {
      Get.snackbar(
          "Required", "Please add some additional infomation for this address");
      return;
    }

    if (addressTag.isEmpty) {
      Get.snackbar("Required", "Please add a Tag for this address");
      return;
    }*/

    if (lat == 0 || lng == 0) {
      Get.snackbar("Required", "Please pick a location for this address");
      return;
    }

    if (addressId == null) {
      Get.snackbar("Something went wrong",
          "Try selecting the address again for updated");
      return;
    }

    showProgress.value = true;

    var result = await RemoteServices.updateAddress(token, addressTag,
        address.value, additionalAddress, lat, lng, addressId!);

    showProgress.value = false;

    if (result != null) {
      if (result.success) {
        fetchMyAddressList();
        Get.back();
        Get.snackbar('Success', result.message);
      } else {
        Get.snackbar('Error', result.message);
      }
    } else {}
  }

  void pickAddress(int position) {
    Log.verbose('is_picking_address = $isPickingAddress');
    if (!isPickingAddress) return;
    var myAddress = addresses[position];
    _checkoutController.addressTag(myAddress.addressTag);
    var address1 = myAddress.aditionalAddress;
    var address2 = myAddress.address;
    _checkoutController.addressDescription.value = "$address1\n$address2";
    _checkoutController.addressId.value = myAddress.id.toString();
    Get.back();
  }
}
