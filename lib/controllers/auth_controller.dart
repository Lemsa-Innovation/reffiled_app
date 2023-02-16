import 'package:get/get.dart';
import 'package:refilled_app/data/model/sign_up_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/otp_model.dart';

class AuthController extends GetxController {
  var showProgress = false.obs;

  Future<bool> checkEmailValid(String email) async {
    var result = await RemoteServices.checkValidEmail(email);
    if (result != null) {
      return result.success;
    } else {
      return false;
    }
  }

  Future<bool> checkMobileExist(String mobile) async {
    var result = await RemoteServices.checkValidMobile(mobile);

    if (result != null) {
      return !result.success;
    } else {
      return true;
    }
  }

  Future<int?> signupUser(
      String name, String mobile, String referralCode) async {
    showProgress.value = true;

    Map<String, String> data = {};
    if(referralCode == '0'){
      data = {
        "name": name,
        "mobile": mobile,
      };
    }

    if(referralCode != '0'){
      data = {
        "name": name,
        "mobile": mobile,
        "referral_code": referralCode,
      };
    }


    var result = await RemoteServices.signupUser(data);
    showProgress.value = false;
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  Future<SignUpResModel?> socialSignIn(
      {required String name,
      required String email,
      required String socialId,
      required String loginBy}) async {
    showProgress.value = true;

    var result =
        await RemoteServices.socialSignIn(name, email, socialId, loginBy);
    showProgress.value = false;
    if (result != null) {
      if (result.success) {
        Get.snackbar('Success', result.message);
        return result;
      } else {
        Get.snackbar('Error', result.message);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<OtpModel?> loginUser(
    String mobile,
  ) async {
    showProgress.value = true;
    var result = await RemoteServices.loginUser(mobile);
    showProgress.value = false;
    if (result != null) {
      if (result.success) {
        return result;
      } else {
        Get.snackbar('Error', result.message);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String?> sendOtp(String phone) async {
    try {
      var result = await RemoteServices.sendOtp(phone);
      if (result != null) {
        //TODO bring this back
        if (result.data?.otp != null) {
          Get.snackbar('Success', result.message);
          return result.data?.otp.toString();
        } else {
          Get.snackbar('Error', result.message);
          return null;
        }
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> setUserData(SignUpResModel signUpRes) async {
    await signUpRes.save();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("is_user_login", true);
    pref.setString("user_token", signUpRes.token ?? '');
    pref.setString('user_id', signUpRes.userData?.id?.toString() ?? '');
    pref.setString('user_name', signUpRes.userData?.name ?? '');
    pref.setString('user_email', signUpRes.userData?.email ?? '');
    pref.setString('user_phone', signUpRes.userData?.mobile ?? '');
    pref.setString('login_type', signUpRes.userData?.loginType ?? '');
    Get.offAllNamed('home');
  }

  Future<bool> verifyOTP(
      {required String phoneNumber, required int pin}) async {
    var response = await RemoteServices.verfieOtp(phoneNumber, pin);
    if (response != null) {
      setUserData(response);
      return true;
    }
    return false;
  }
}
