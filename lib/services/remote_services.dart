import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:refilled_app/data/model/add_address_res_model.dart';
import 'package:refilled_app/data/model/apply_promo_res_model.dart';
import 'package:refilled_app/data/model/base_res_model.dart';
import 'package:refilled_app/data/model/cards_res_model.dart';
import 'package:refilled_app/data/model/cart_res_model.dart';
import 'package:refilled_app/data/model/check_email_res_model.dart';
import 'package:refilled_app/data/model/check_mobile_res_model.dart';
import 'package:refilled_app/data/model/delete_address_res_model.dart';
import 'package:refilled_app/data/model/edit_address_res_model.dart';
import 'package:refilled_app/data/model/live_order_tracking_res_model.dart';
import 'package:refilled_app/data/model/my_address_res_model.dart';
import 'package:refilled_app/data/model/orders_res_model.dart';
import 'package:refilled_app/data/model/past_order_detail_res_model.dart';
import 'package:refilled_app/data/model/product_category_res_model.dart';
import 'package:refilled_app/data/model/product_detail_res_model.dart';
import 'package:refilled_app/data/model/product_res_model.dart';
import 'package:refilled_app/data/model/referral_code_res_model.dart';
import 'package:refilled_app/data/model/send_otp_res_model.dart';
import 'package:refilled_app/data/model/sign_up_res_model.dart';
import 'package:refilled_app/data/model/track_order_res_model.dart';
import 'package:refilled_app/data/model/update_profile_res_model.dart';
import 'package:refilled_app/data/model/wallet_balance_res_model.dart';
import 'package:refilled_app/data/model/wallet_res_model.dart';
import 'package:refilled_app/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/create_order_res_model.dart';
import '../data/model/otp_model.dart';
import '../utils/global.dart';

//$url/

//http://144.91.80.25:4006
final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

class RemoteServices {
  static var client = http.Client();

  static Future<CheckEmailResModel?> checkValidEmail(String email) async {
    var response =
        await client.get(Uri.parse('$url/api/user/checkemail/$email'));
    Log.verbose(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      log("response is == $jsonString");
      return checkEmailResModelFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<CheckMobileResModel?> checkValidMobile(String mobile) async {
    var response =
        await client.get(Uri.parse('$url/api/user/checkmobile/$mobile'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return checkMobileResModelFromJson(jsonString);
    } else {
      return null;
    }
  }

  static Future<SendOtpResModel?> sendOtp(String phone) async {
    var response = await client.get(Uri.parse('$url/api/user/sendOtp/$phone'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return sendOtpResModelFromJson(jsonString);
    } else {
      return null;
    }
  }

  static Future<SignUpResModel?> verfieOtp(String mobile, int otp) async {
    try {
      var response = await Dio().postUri(Uri.parse('$url/api/user/otp/confirm'),
          data: {'mobile': mobile, 'otp': otp});
      if (response.statusCode == 200) {
        return SignUpResModel.fromJson(response.data);
      }
      return null;
    } on DioError {
      return null;
    }
  }

  static Future<int?> signupUser(Map<String, String> info) async {
    var deviceInfo = DeviceInfoPlugin();
    var deviceId = Platform.isAndroid
        ? (await deviceInfo.androidInfo).androidId
        : Platform.isIOS
            ? (await deviceInfo.iosInfo).identifierForVendor
            : null;
    Map data = {
      "name": info['name'],
      "email": info['email'],
      "mobile": info['mobile'],
      "referral_code": info['referral_code'],
      "deviceId": deviceId,
      "loginType": "Manual",
      "deviceType": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? 'IOS'
              : 'Other',
      "fcmToken": await FirebaseMessaging.instance.getToken(),
    };
    var response = await client.post(Uri.parse('$url/api/user/signup'),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

    Log.warning('signup '+ response.body.toString() );
    if(jsonDecode(response.body)['error'] == true){
      Get.snackbar('Try again!', jsonDecode(response.body)['message'], backgroundColor: const Color(0xFF29ABE2));
    }
    if (response.statusCode == 200) {

      Log.warning('signup '+ response.body.toString() );

      return jsonDecode(response.body)['otp'];
    }
    return null;
  }

  @Deprecated('This not working any more use signupUser instead')
  static Future<SignUpResModel?> createUser(
      String name, String email, String mobile, String referralCode) async {
    var deviceInfo = DeviceInfoPlugin();
    var deviceId = Platform.isAndroid
        ? (await deviceInfo.androidInfo).androidId
        : Platform.isIOS
            ? (await deviceInfo.iosInfo).identifierForVendor
            : null;
    Map data = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "referral_code": referralCode,
      "deviceId": deviceId,
      "loginType": "Manual",
      "deviceType": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? 'IOS'
              : 'Other',
      "fcmToken": await FirebaseMessaging.instance.getToken(),
    };

    var body = jsonEncode(data);

    var response = await client.post(Uri.parse('$url/api/user/signup'),
        headers: {"Content-Type": "application/json"}, body: body);
    Log.verbose('signUpUser==>${response.body}');
    if (response.statusCode == 200) {
      return signUpResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<SignUpResModel?> socialSignIn(
    String name,
    String email,
    String socialId,
    String loginBy,
  ) async {
    var deviceInfo = DeviceInfoPlugin();
    var deviceId = Platform.isAndroid
        ? (await deviceInfo.androidInfo).androidId
        : Platform.isIOS
            ? (await deviceInfo.iosInfo).identifierForVendor
            : null;
    Map data = {
      "name": name,
      "email": email,
      "mobile": "",
      "deviceId": deviceId,
      "loginType": loginBy,
      "deviceType": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? 'IOS'
              : 'Other',
      "socialToken": socialId,
      "latitude": "0",
      "longitude": "0",
      "fcmToken": await FirebaseMessaging.instance.getToken()
    };

    var body = jsonEncode(data);

    var response = await client.post(Uri.parse('$url/api/user/social'),
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      log(' social sign up res = ${response.body}');
      return signUpResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<OtpModel?> loginUser(String phone) async {
    var response = await client.post(Uri.parse('$url/api/user/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": phone}));
    Log.verbose(phone);
    if (response.statusCode == 200) {
      Log.verbose(response.body);
      return OtpModel.fromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<MyAddressResModel?> fetchMyAddressList(String token) async {
    var response = await client.get(
      Uri.parse('$url/api/user/address'),
      headers: {"Content-Type": "application/json", "Authorization": token},
    );
    log("status code is = ${response.statusCode}");
    if (response.statusCode == 200) {
      log("my_address_list_res = ${response.body}");
      return myAddressResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<AddAddressResModel?> addAddress(String token, String addressTag,
      String address, String additionalAddress, double lat, double lng) async {
    Map data = {
      "addressTag": addressTag,
      "address": address,
      "aditionalAddress": additionalAddress,
      "latitude": lat,
      "longitude": lng

    };
    Log.warning('Sending address=>$data');

    var body = jsonEncode(data);

    try {
      var response = await client.post(Uri.parse('$url/api/user/createaddress'),
          headers: {'Content-Type': 'application/json', "Authorization": token},
          body: body);

      Log.warning('Sending address=>${response.body}');

      //  Logger().e(response.body);
      if (response.statusCode == 200) {
        return addAddressResModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<DeleteAddressResModel?> deleteAddress(
      String token, int addressId) async {
    var response = await client.delete(
        Uri.parse('$url/api/user/address/$addressId'),
        headers: {'Content-Type': 'application/json', "Authorization": token});

    if (response.statusCode == 200) {
      return deleteAddressResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<EditAddressResModel?> updateAddress(
      String token,
      String addressTag,
      String address,
      String additionalAddress,
      double lat,
      double lng,
      int addressId) async {
    Map data = {
      "addressTag": addressTag,
      "address": address,
      "aditionalAddress": additionalAddress,
      "latitude": lat,
      "longitude": lng
    };

    var body = jsonEncode(data);

    var response = await client.post(
        Uri.parse('$url/api/user/editaddress/$addressId'),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);

    if (response.statusCode == 200) {
      return editAddressResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<ProductCategoryResModel?> fetchProductCategories(
      String token, LatLng? userLocation) async {
    var baseUrl = '$url/api/user/category';
    if (userLocation != null) {
      baseUrl +=
          '?user_latitude=${userLocation.latitude}&user_longitude=${userLocation.longitude}';
    }
    var response = await client.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    if (response.statusCode == 200) {
      return productCategoryResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<ProductResModel?> fetchPopularProducts(String token,
      {LatLng? userLocation}) async {
    String uri = '$url/api/user/popularproducts?';
    if (userLocation != null) {
      uri +=
          'user_latitude=${userLocation.latitude}&user_longitude=${userLocation.longitude}';
    }

    var response = await client.get(Uri.parse(uri),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      return productResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<ProductResModel?> fetchProducts(String token, int categoryId,
      {double? latitude, double? longitude}) async {
    String uri = '$url/api/user/products/$categoryId?';
    if (latitude != null) {
      uri += 'user_latitude=$latitude';
    }
    if (longitude != null) {
      uri += '&user_longitude=$longitude';
    }
    //uri = '$url/api/user/products/$categoryId?user_latitude=36.756744&user_longitude=2.849264';
    log(uri);
    var response = await client.get(
      Uri.parse(uri),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    if (response.statusCode == 200) {
      log(response.body);
      return productResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<ProductResModel?> fetchAllProducts(String token, {double? latitude, double? longitude}) async {
    String uri = '$url/api/user/products?';
    if (latitude != null) {
      uri += 'user_latitude=$latitude';
    }
    if (longitude != null) {
      uri += '&user_longitude=$longitude';
    }
    //uri = '$url/api/user/products/$categoryId?user_latitude=36.756744&user_longitude=2.849264';
    log(uri);
    var response = await client.get(
      Uri.parse(uri),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    if (response.statusCode == 200) {
      log(response.body);
      return productResModelFromJson(response.body);
    } else {
      return null;
    }
  }


  static Future<ProductDetailResModel?> fetchProductDetail(
      String token, int productId, LatLng? location) async {
    log("productId= $productId");
    var uri = '$url/api/user/product/$productId';
    if (location != null) {
      uri +=
          '?user_latitude=${location.latitude}&user_longitude=${location.longitude}';
    }
    var response = await client.get(
      Uri.parse(uri),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    if (response.statusCode == 200) {
      log("Product detail res is  ==>  ${response.body}");
      return productDetailModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<UpdateProfileResModel?> updateProfile(
      String token, Map<String, dynamic> toUpdate) async {
    var response = await client.put(Uri.parse('$url/api/user/updateprofile'),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: json.encode(toUpdate));
    Log.verbose(response.body);
    if (response.statusCode == 200) {
      return updateProfileResModelFromJson(response.body);
    } else {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['message'] ?? 'Error');
      return null;
    }
  }

  static Future<BaseResModel?> addToCart(
      String token, int productId, int quantity) async {

    SharedPreferences pref = await _pref;

    String? state = await pref.getString('currentState');

    Map data = {"product_id": productId, "quantity": quantity};

    var body = json.encode(data);
    log("add To cart request = $body");

    var response = await client.post(Uri.parse('$url/api/user/addintocart?state='+ (state!.length<=3 ? state : 'AL')),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);
    log(response.body);
    if (response.statusCode == 200) {
      return baseResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<CartResModel?> getMyCart(String token) async {
    SharedPreferences pref = await _pref;

    String? state = await pref.getString('currentState');
    var response = await client.get(Uri.parse('$url/api/user/cart?state=' + (state!.length<=3 ? state : 'AL')),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    log("::::: uri" + Uri.parse('$url/api/user/cart?state='+state!).toString());
    if (response.statusCode == 200) {
      return cartResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> deleteItemFromCart(
      String token, int productId) async {
    SharedPreferences pref = await _pref;

    String? state = await pref.getString('currentState');
    var response = await client.delete(
        Uri.parse('$url/api/user/cart/product/$productId?state=' + (state!.length<=3 ? state : 'AL')),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      return baseResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> addNewCard(String token, String cardHolderName,
      String cardNumber, String validUpTo) async {
    Map data = {
      "card_holder_name": cardHolderName,
      "card_number": cardNumber,
      "valid_upto": validUpTo
    };

    var body = json.encode(data);

    var response = await client.post(Uri.parse('$url/api/user/paymentmethod'),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);
    if (response.statusCode == 200) {
      return baseResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<CardsResModel?> getCards(
    String token,
  ) async {
    var response = await client.get(Uri.parse('$url/api/user/paymentmethods'),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      log("get cards res is = ${response.body}");
      return cardsResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> deleteCard(String token, int cardId) async {
    var response = await client.delete(
        Uri.parse('$url/api/user/paymentmethod/$cardId'),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      log("delete cards res is = ${response.body}");
      return baseResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<ProductResModel?> searchProducts(String token, String keyword,
      {double? latitude, double? longitude}) async {
    String uri = '$url/api/user/products/search?';
    if (latitude != null) {
      uri += 'user_latitude=$latitude';
    }
    if (longitude != null) {
      uri += '&user_longitude=$longitude';
    }
    Map data = {'keyword': keyword};

    var body = jsonEncode(data);
    var response = await client.post(Uri.parse(uri),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);
    if (response.statusCode == 200) {
      return productResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> confirmOrder(
      String token,
      String cardNumber,
      String expMonth,
      String expYear,
      String cvc,
      String email,
      String name,
      String amount,
      String addressId,
      String deliveryTime,
      String deliveryAmount,
      String promoAmount,
      String walletAmount) async {
    Map data = {
      'card_number': cardNumber,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cvc': cvc,
      'email': email,
      'name': name,
      'amount': amount,
      'address_id': addressId,
      'delivery_time': deliveryTime,
      'delivery_amount': deliveryAmount,
      'promo_amount': promoAmount,
      'wallet_amount': walletAmount,
    };

    var body = jsonEncode(data);

    log('requestBody = $body');
    var response = await client.post(Uri.parse('$url/api/user/confirmorder'),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);
    log("Confirm order status == ${response.statusCode}");
    if (response.statusCode == 200) {
      log('Confirm order res  => ${response.body}');

      return baseResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<OrdersResModel?> getUpcomingOrders(
    String token,
  ) async {
    var response = await client.get(Uri.parse('$url/api/user/orders'),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      log("upcoming orders res is = ${response.body}");
      return ordersResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<OrdersResModel?> getPastOrders(
    String token,
  ) async {
    var response = await client.get(Uri.parse('$url/api/user/pastorders'),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      log("pastOrders orders res is = ${response.body}");
      return ordersResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<void> updateFcmToken(String token, String fcmToken) async {
    Map data = {
      'fcmToken': fcmToken,
    };
    var body = jsonEncode(data);
    var response = await client.post(Uri.parse('$url/api/user/updatefcmtoken'),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);
    if (response.statusCode == 200) {
      log("Fcm token updated successfully");
    }
  }

  static Future<ApplyPromoResModel?> applyPromoCode(
      String token, String promoCode) async {
    var response = await client.get(
      Uri.parse('$url/api/user/promocode/$promoCode'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );
    if (response.statusCode == 200) {
      Logger().v(response.body);
      return applyPromoResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<TrackOrderResModel?> getTrackOrderDetail(
      String token, String orderId) async {
    log('token = $token');
    log('orderId = $orderId');

    var response = await client.get(
      Uri.parse('$url/api/user/trackorder/$orderId'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('Track order res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log('Track order res  => ${response.body}');
      return trackOrderResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<LiveOrderTrackingResModel?> getLiveTrackingOrderDetail(
      String token, String orderId) async {
    log('token = $token');
    log('orderId = $orderId');

    var response = await client.get(
      Uri.parse('$url/api/user/livetrackorder/$orderId'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('Track order res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log(' live Track order res  => ${response.body}');
      return liveOrderTrackingResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<PastOrderDetailResModel?> getPastOrderDetail(
      String token, String orderId) async {
    log('token = $token');
    log('orderId = $orderId');
    var response = await client.get(
      Uri.parse('$url/api/user/pastorderdetail/$orderId'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('Track order res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log('past order detail res  => ${response.body}');
      return pastOrderDetailResModelFromJson(response.body);
    } else {
      return null;
    }
  }


  static Future<Map?> getSettings(
      String token,
      ) async {
    log('token = $token');
    var response = await client.get(
      Uri.parse('$url/api/settings/user'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('referral code res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log('settings res  => ${response.body}');
      return json.decode(response.body) ;
    } else {
      return null;
    }
  }

  static Future<ReferralCodeResModel?> getReferralCode(
    String token,
  ) async {
    log('token = $token');
    var response = await client.get(
      Uri.parse('$url/api/user/referral'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('referral code res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log('referral code  res  => ${response.body}');
      return referralCodeResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<WalletResModel?> fetchWalletData(
    String token,
  ) async {
    log('token = $token');
    var response = await client.get(
      Uri.parse('$url/api/user/wallet'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('wallet  res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log('wallet  res  => ${response.body}');
      return walletResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<WalletBalanceResModel?> getWalletBalance(
    String token,
  ) async {
    log('token = $token');
    var response = await client.get(
      Uri.parse('$url/api/user/walletamount'),
      headers: {'Content-Type': 'application/json', "Authorization": token},
    );

    log('wallet  res status => ${response.statusCode}');
    if (response.statusCode == 200) {
      log('wallet balance  res  => ${response.body}');
      return walletBalanceResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> cancelOrder(String token, String orderId) async {
    var response = await client.get(
        Uri.parse('$url/api/user/cancelorder/$orderId'),
        headers: {'Content-Type': 'application/json', "Authorization": token});
    if (response.statusCode == 200) {
      log("Cancel order res = ${response.body}");
      return baseResModelFromJson(response.body);
    } else {
      return null;
    }
  }

  // static Future<String?> createPaymentIntent

//TODO: CREATE ORDER BY APPLE OR GOOGLE PAY STEP ONE
  static Future<CreateOrder?> createOrder(
      String token,
      String amount,
      String deliveryTime,
      int deliveryAmount,
      String promoAmount,
      int addressId,
      int walletAmount) async {
    Map data = {
      "amount": amount,
      "delivery_amount": deliveryTime,
      "delivery_time": deliveryAmount,
      "promo_amount": promoAmount,
      "address_id": addressId,
      "wallet_amount": walletAmount
    };

    var body = jsonEncode(data);

    var response = await client.post(Uri.parse('$url/api/user/createorder'),
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: body);

    log("Create Order Status = ${response.statusCode}");
    if (response.statusCode == 200) {
      return createOrderFromMap(response.body);
    } else {
      return null;
    }
  }
}
