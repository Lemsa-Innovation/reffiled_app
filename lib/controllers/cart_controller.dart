import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:refilled_app/data/model/cart_res_model.dart';
import 'package:refilled_app/data/model/delivery_option.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  List<DeliveryOption> deliveryOptions = [
    DeliveryOption('\$2.99 ', '40 minute delivery'),
    DeliveryOption('\$5.99 ', '20 minute delivery'),
  ];

  final promoCodeEditingController = TextEditingController();

  final deliveryPrice = [
    2.99,
    5.99,
  ];

  var showProgress = false.obs;

  var cartItems = <CartItem>[].obs;
  var subTotal = 0.obs;
  var tax = 0.0.obs;
  var total = 0.0.obs;
  var stateFee = 0.0.obs;
  var driverBenefitsFee = 0.0.obs;

  var deliveryType = 0.obs; // for delivery array index either 1 or 0
  var deliveryAmount = 0.0.obs;
  var deliveryTime = ''.obs;

  var isCouponApplied = false.obs;
  var couponAmount = 0.0;
  var couponCode = ''.obs;
  var totalItemsInCart = 0.obs;
  var walletAmount = 0.obs;
  var usedWalletAmount = 0.obs;
  var isUseWalletAmount = false.obs;
  var ordersStatus = false.obs;

  @override
  void onInit() {
    getSettings();
    isUseWalletAmount.value = false;
    deliveryTime.value = deliveryOptions[deliveryType.value].deliveryTime;
    deliveryAmount.value = deliveryPrice[deliveryType.value];
    getMyCart();
    super.onInit();
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

  Future<bool> updateCartItem(int position, int quantity) async {
    showProgress.value = true;

    SharedPreferences pref = await _pref;

    String token = pref.getString('user_token') ?? "";

    var productId = cartItems[position].productId;

    var result = await RemoteServices.addToCart(token, productId, quantity);
    showProgress.value = false;

    if (result != null) {
      if (result.success) {
        getMyCart();
      } else {
        Get.snackbar("Error", result.message);
      }
      return result.success;
    }

    return false;
  }

  void getMyCart() async {
    totalItemsInCart.value = 0;
    SharedPreferences pref = await _pref;

    String token = pref.getString('user_token') ?? "";
    var result = await RemoteServices.getMyCart(token);
    log("cart : ${result?.stateTaxRate}");
    if (result != null) {
      if (result.success) {
        for (var item in result.data) {
          totalItemsInCart.value += item.quantity;

        }

        cartItems.value = result.data;
        subTotal.value = result.subtotal;
        tax.value = result.tax;
        stateFee.value = result.stateTaxRate;
        driverBenefitsFee.value = result.driverBenefitsFee;

        total.value =
            result.subtotal + result.tax+ result.driverBenefitsFee+ deliveryPrice[deliveryType.value] + result.stateTaxRate;
      } else {
        Get.snackbar('Error', result.message);
      }
    }
  }

  void   deleteItemFromCart(int position) async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? "";
    var result = await RemoteServices.deleteItemFromCart(
        token, cartItems[position].productId);

    if (result != null) {
      if (result.success) {
        getMyCart();
      } else {
        Get.snackbar("Error", result.message);
      }
    }
    showProgress.value = false;
  }

  void selectDeliveryType(int type) {
    deliveryType.value = type;
    total.value = subTotal.value + tax.value + deliveryPrice[type];
  }

  void addItemQuantity(int position) {
    var quantity = cartItems[position].quantity + 1;
    updateCartItem(position, quantity);
  }

  void removeItemQuantity(int position) {
    var quantity = cartItems[position].quantity;
    if (quantity == 1) {
      deleteItemFromCart(position);
    } else {
      quantity -= 1;
      updateCartItem(position, quantity);
    }
  }

  Future<bool> addProductToCart(int productId) async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? '';

    showProgress.value = true;
    var result = await RemoteServices.addToCart(token, productId, 1);

    if (result != null) {
      if (result.success) {
        Get.snackbar(
            'Added Successfully', "Product successfully added to your cart");
        getMyCart();
      } else {
        Get.snackbar("Error", result.message);
      }
    }

    showProgress.value = false;

    return false;
  }

  void getWalletBalance() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    var result = await RemoteServices.getWalletBalance(token);
    if (result != null) {
      if (result.success) {
        walletAmount.value = result.data.walletAmount;
      }
    }
  }

  void applyCoupon() async {
    String promoCode = promoCodeEditingController.text.toString().trim();

    if (promoCode.isEmpty) {
      Get.snackbar("Required", "Please enter a valid Promo Code");
      return;
    }

    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';

    var result = await RemoteServices.applyPromoCode(token, promoCode);
    if (result != null) {
      if (result.success) {
        isCouponApplied(true);
        total(total.value - result.data!.value);
        couponCode(result.data!.code);
        couponAmount = result.data!.value.toDouble();
        promoCodeEditingController.clear();
      } else {
        Get.snackbar('Error', result.message);
        isCouponApplied.value = false;
      }
    } else {
      isCouponApplied.value = false;
    }
  }

  void setUseWalletAmount(bool useAmount) {
    isUseWalletAmount.value = useAmount;
    if (useAmount) {
      total.value -= getActualUseAmount();
    } else {
      total.value += getActualUseAmount();
    }
  }

  double getActualUseAmount() {
    var halfOfTotalAmount = subTotal / 2.0;
    if (walletAmount > halfOfTotalAmount) {
      usedWalletAmount.value = halfOfTotalAmount.toInt();
      return halfOfTotalAmount;
    } else {
      usedWalletAmount.value = walletAmount.value;
      return walletAmount.value.toDouble();
    }
  }

  void removeCouponCode() {
    isCouponApplied.value = false;
    couponCode.value = '';
    total.value += couponAmount;
    couponAmount = 0.0;
  }

  clearCart() {
    showProgress.value = true;
    for (var i = 0; i < cartItems.length; i++) {
      deleteItemFromCart(i);
    }
    totalItemsInCart.value = 0;
    showProgress.value = false;
  }
}
