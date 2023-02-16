import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refilled_app/controllers/product_controller.dart';
import 'package:refilled_app/data/model/sign_up_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:refilled_app/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  LatLng currentPosition = const LatLng(0.0, 0.0);
  var address = "Fetching your location...".obs;
  var ordersStatus = false.obs;
  var stillFetching = true.obs;
  Rxn<LatLng> currentUserLocation = Rxn();
  @override
  void onInit() {
    super.onInit();
    getSettings();

    Log.debug('INIT HomeController');
    setUserLogin(true);
    checkIfNumberRequired();
    getUserLocation();
  }

  Future<bool> getSettings() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';

    var result = await RemoteServices.getSettings(token);

    if (result != null) {
      if (result["success"]) {
        ordersStatus.value = result["data"]["security"]["ordersStatus"];
        return true;
      } else {
        Get.snackbar('Error', result["message"]);
        return false;
      }
    }
    return true;

  }

  void setUserLogin(bool isLogin) async {
    SharedPreferences pref = await _pref;
    pref.setBool("is_user_login", isLogin);
  }

  void checkIfNumberRequired() async {
    var user = await SignUpResModel.load();

    if (user != null &&
        (user.userData?.mobile == null ||
            user.userData!.mobile!.isEmpty ||
            user.userData!.mobile == '0')) {
      showMissingPhoneNumberAlert();
    }
  }

  Future<bool> checkForLocationPermission() async {
    var serviceEnabled =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Your GPS is Disabled');
      return false;
    }
    if (await Permission.locationWhenInUse.isGranted) {
      return true;
    } else {
      var isGranted = await Permission.locationWhenInUse.request().isGranted;
      if (isGranted) {
        return true;
      } else {
        Get.defaultDialog(
            title: "Permission Denied",
            contentPadding: const EdgeInsets.all(10),
            titleStyle: const TextStyle(
                color: Color(0xFF061737),
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                fontSize: 16),
            middleText:
                "Location permission required to access your current location and Get Product in your area",
            middleTextStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,
                fontSize: 14),
            actions: [
              TextButton(
                  onPressed: () async {
                    await GeolocatorPlatform.instance.openAppSettings();
                    Get.until((route) => route.isFirst);
                  },
                  child: const Text('Open App settings'))
            ]);
        return false;
      }
    }
  }

  void searchAddress() async {
    dynamic result = await Get.toNamed('/search_place');
    if (result == null) return;
    currentPosition = LatLng(result['lat'], result['lng']);
    currentUserLocation(currentPosition);
    saveSelectedLocation(currentPosition.latitude, currentPosition.longitude);
    address.value = await Global.getAddress(
        currentPosition.latitude, currentPosition.longitude);
    String currentState = await Global.getStateName(currentPosition.latitude, currentPosition.longitude);
    SharedPreferences pref = await _pref;

    pref.setString('currentState', currentState);


  }

  void updateFcmToken(String fcmToken) async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    await RemoteServices.updateFcmToken(token, fcmToken);
  }

  void saveSelectedLocation(double lat, double lon) async {
    SharedPreferences pref = await _pref;
    pref.setDouble("lat", lat);
    pref.setDouble("lng", lon);
  }

  void showLogoutAlert() {
    Get.defaultDialog(
        radius: 8,
        contentPadding: const EdgeInsets.all(8),
        barrierDismissible: false,
        title: "Logout",
        titleStyle: const TextStyle(
            color: Color(0xFF061737),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 16),
        middleText: "Are you sure you want to Logout? ",
        middleTextStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
            fontSize: 14),
        cancel: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF29ABE2), width: 1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                )),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Text("cancel",
                  style: TextStyle(
                      color: Color(0xFF29ABE2),
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
            )),
        confirm: ElevatedButton(
            onPressed: () {
              Get.back();
              logoutUser();
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD14444)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                "Logout",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )));
  }

  void logoutUser() async {
    SharedPreferences pref = await _pref;
    pref.setBool("is_user_login", false);
    Get.offAllNamed('/login');
  }

  void showMissingPhoneNumberAlert() {
    Get.defaultDialog(
        radius: 8,
        contentPadding: const EdgeInsets.all(8),
        barrierDismissible: false,
        title: "Add Mobile",
        titleStyle: const TextStyle(
            color: Color(0xFF061737),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 16),
        middleText:
            "Your contact number is missing please update your contact number in profile.",
        middleTextStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
            fontSize: 14),
        cancel: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF29ABE2), width: 1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                )),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Text("cancel",
                  style: TextStyle(
                      color: Color(0xFF29ABE2),
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
            )),
        confirm: ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/profile');
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD14444)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                "Update",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )));
  }

  Future<LatLng?> getUserLocation() async {
    Get.put<ProductController>(ProductController()).isWorking(true);
    address('Fetching your location...');
    try {
      var isHavingLocationPermission = await checkForLocationPermission();
      if (isHavingLocationPermission) {

        SharedPreferences pref = await _pref;
        double? lat = pref.getDouble("lat");
        double? lon = pref.getDouble("lng");
        if(lat == null || lon == null || lon == 0.0 || lat == 0.0){
          Log.warning(lat.toString()+' ' +lon.toString());

          var position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          currentPosition = LatLng(position.latitude, position.longitude);
          address.value = await Global.getAddress(position.latitude, position.longitude);
        }
        // var position = await Geolocator.getCurrentPosition(
        //     desiredAccuracy: LocationAccuracy.high);
        // currentPosition = LatLng(position.latitude, position.longitude);

        if(lat != null && lon != null && lat != 0.0 && lon != 0.0){
          address.value = await Global.getAddress(
              lat, lon);
          saveSelectedLocation(
              currentPosition.latitude, currentPosition.longitude);
          currentPosition = LatLng(lat, lon);
        }



        currentUserLocation(currentPosition);
        stillFetching.value = false;


        return currentUserLocation.value;

      }
      address('Permission Denied\nclick here to set address Manually');
      return null;
    } finally {
      Get.find<ProductController>().isWorking(false);
    }
  }
}
