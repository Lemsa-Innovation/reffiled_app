import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:us_states/us_states.dart';

const url = 'https://api-backend.refilled.co';
final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

class Global {


  static String getImageUrl(String? imageUrl) {
    if (imageUrl == null) return "";

    if (imageUrl.startsWith('http')) {
      return url;
    } else {
      return url + '/${imageUrl.replaceAll('\\', '/')}';
    }
  }

  static String formatPrice(double price) {
    final format = NumberFormat("#,##0.00", "en_US");
    try {
      return '\$${format.format(price).toString()}';
    } catch (e) {
      return 'NA';
    }
  }

  static String formatPriceDouble(double price) {
    final format = NumberFormat("#,##0.00", "en_US");
    try {
      return '\$${format.format(price).toString()}';
    } catch (e) {
      return 'NA';
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Error", "Can't launch this url");
    }
  }

  static Future<String> getAddress(double latitude, double longitude) async {
    if (latitude == 0 || longitude == 0) return 'unknow Address';

    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    log("placemark-----   $placemark");
    if (placemark.isNotEmpty) {
      var name = placemark[0].street ?? "";
      var subLocality = placemark[0].subLocality ?? "";
      var adminArea = placemark[0].subAdministrativeArea ?? "";

      StringBuffer result = StringBuffer();

      if (name.isNotEmpty) {
        result.write(name);
        result.write(", ");
      }

      if (subLocality.isNotEmpty) {
        result.write(subLocality);
        result.write(", ");
      }
      if (adminArea.isNotEmpty) {
        result.write(adminArea);
      }
      if (result.isEmpty) {
        result.write('unnamed area');
      }
      return result.toString();
    }
    return "unnamed area";
  }

  static Future<String> getAddressName(
      double latitude, double longitude) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    log("placemark-----   $placemark");
    if (placemark.isNotEmpty) {
      return placemark[0].street ?? "unnamed arae";
    } else {
      return "unnamed area";
    }
  }


  static Future<String> getStateName(
      double latitude, double longitude) async {
    List<Placemark> placemark =
    await placemarkFromCoordinates(latitude, longitude);
    log("placemark-----   ${placemark.runtimeType}");
    if (placemark.isNotEmpty) {

      return USStates.getAbbreviation(placemark[0].administrativeArea ?? 'AL') ?? "unnamed arae";


    } else {
      return "unnamed area";
    }
  }


}
