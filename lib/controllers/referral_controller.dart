import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var showProgress = false.obs;
  var referralCode = ''.obs;
  RxString refPrice = ''.obs;
  var senderBonus = false.obs;
  var recipientBonus = false.obs;
  var deliveryBonus = false.obs;


  @override
  void onInit() {
    getReferralInformation();

    getReferralCode();
    super.onInit();
  }

  void getReferralCode() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    showProgress.value = false;
    var result = await RemoteServices.getReferralCode(token);
    showProgress.value = false;
    if (result != null) {
      if (result.success) {
        referralCode.value = result.data!.referralCode;
      } else {
        Get.snackbar('Error', result.message);
      }
    }
  }



  void getReferralInformation() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    showProgress.value = false;
    var result = await RemoteServices.getSettings(token);


    showProgress.value = false;
    if (result != null) {
      if (result["success"]) {
        refPrice.value = result["data"]["referral"]["bonus"].toString();
        senderBonus.value = result["data"]["referral"]["sender"];
        recipientBonus.value = result["data"]["referral"]["recipient"];
        deliveryBonus.value = result["data"]["referral"]["delivery"];
      } else {
        Get.snackbar('Error', result["message"]);
      }
    }
  }


  Future<void> shareReferralCode() async {

 /*   FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: 'https://cdn.mos.cms.futurecdn.net/CAZ6JXi6huSuN4QGE627NR.jpg',
    );*/

    await FlutterShare.share(
        title: 'Refilled',
        text: 'Signup on Refilled using referral code\n\n${referralCode.value}\nand get referral bonus.\n\nDownload Refilled app from \nwww.refilled.com',
        chooserTitle: "Choose from options");
  }

  void codeToClipBoard(){
    Clipboard.setData(ClipboardData(text: referralCode.value)).then((_) => {
      Get.snackbar('Copied', 'Successfully copied to clipboard')
    });


  }
}
