import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:refilled_app/data/model/wallet_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var referrals = <Referral>[].obs;
  var walletAmount = 0.obs;

  var showProgress = false.obs;

  @override
  void onInit() {
    getWallet();
    super.onInit();
  }

  void getWallet() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    showProgress.value = true;
    var result = await RemoteServices.fetchWalletData(token);
    showProgress.value = false;
    if (result != null) {
      if (result.success) {
        log("wallet $result");
        referrals.addAll(result.data);
        walletAmount.value = result.walletAmount;
      } else {
        Get.snackbar('Error', result.message);
      }
    }
  }

  String formatDate(DateTime value) {
    DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(value);
  }
}
