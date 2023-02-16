import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refilled_app/data/model/cards_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_controller.dart';

class CheckoutController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _cartController = Get.put(CartController());

  var addressTag = ''.obs;
  var addressDescription = ''.obs;
  var addressId = ''.obs;
  var cvv = ''.obs;

  MyCard? selectedCard;

  var amount = 0.0.obs;
  var deliveryAmount = '';
  var deliveryTime = '';
  var promoAmount = '';
  var walletAmount = '';

  var showProgress = false.obs;

  @override
  void onInit() {
    fetchMyAddressList();
    amount.value = _cartController.total.value;
    deliveryTime = _cartController.deliveryTime.value;
    deliveryAmount = _cartController.deliveryAmount.value.toString();
    promoAmount = _cartController.isCouponApplied.value
        ? _cartController.couponAmount.toString()
        : '0.0';
    walletAmount = _cartController.isUseWalletAmount.value
        ? _cartController.usedWalletAmount.value.toString()
        : '0.0';
    super.onInit();
  }

  Future<void> fetchMyAddressList() async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? "";
    var result = await RemoteServices.fetchMyAddressList(token);
    if (result != null) {
      if (result.success) {
        addressId.value = '';
        if (result.data?.isNotEmpty == true) {
          var myAddress = result.data?.first;
          addressTag.value = myAddress?.addressTag ?? '';

          var address1 = myAddress?.aditionalAddress ?? '';
          var address2 = myAddress?.address ?? '';

          if (myAddress?.address != null) {}

          addressDescription.value = "$address1\n$address2";
          addressId.value = myAddress?.id.toString() ?? '';
        }
      } else {
        Get.snackbar("Error", result.message);
      }
    }

    showProgress.value = false;
  }

  void validateOrderData() async {
    if (addressId.isEmpty) {
      Get.snackbar(
          'Delivery Address Missing', 'Please Enter Your Delivery Address');
      return;
    }

    if (selectedCard == null) {
      Get.snackbar('Card details missing', 'Please select a card for payment');
      return;
    }
    cvv.value = '';
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24))),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter CVV/CVC number of your Personal card ending with (*${selectedCard?.cardNumber.split(' ').last})',
            style: const TextStyle(
                color: Color(0xFF061737),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            keyboardType: TextInputType.number,
            cursorColor: Colors.grey,
            maxLength: 4,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintText: 'CVV',
                hintStyle: TextStyle(
                  color: Color(0xFFD9D9D9),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF061737),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                )),
            onChanged: (value) {
              cvv.value = value;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Obx(
            () => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: ElevatedButton(
                  onPressed: () {
                    if (cvv.value.length > 2) {
                      Get.back();
                      confirmOrder();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      primary: const Color(0xFF239CCC),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29.0))),
                  child: Container(
                    height: 58,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(29),
                        gradient: LinearGradient(colors: [
                          cvv.value.length > 2
                              ? const Color(0xFF0EE2F5)
                              : Colors.grey,
                          cvv.value.length > 2
                              ? const Color(0xFF29ABE2)
                              : Colors.grey
                        ])),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 60),
                    child: const Center(
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    ));
  }

  void confirmOrder() async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    String email = pref.getString('user_email') ?? '';
    String name = pref.getString('user_name') ?? '';
    var result = await RemoteServices.confirmOrder(
        token,
        selectedCard!.cardNumber,
        selectedCard!.validUpto.split('/').first,
        selectedCard!.validUpto.split('/').last,
        cvv.value,
        email,
        name,
        amount.value.toStringAsFixed(2),
        addressId.value,
        deliveryTime,
        deliveryAmount,
        promoAmount,
        walletAmount);

    showProgress.value = false;

    if (result != null) {
      if (result.success) {
        Get.toNamed('/confirm_order');
      } else {
        Get.snackbar('Error', result.message);
      }
    }
  }
}

/* final String secret_key =
      'sk_test_51Jpu1NSGuekmXOFIwISYe0zDEZrbxRQiqlfvZT7y0Uv2EzJwxdADlNyAMp8rG9NABGQzVpBRlYCntyPy0mjM2Iq800Y6Ir5tel';

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent("20", "USD");

      print('paymentIntentData  =$paymentIntentData');

      final billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); //

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            // customFlow: true,
            applePay: true,
            googlePay: true,
             testEnv: true,
            style: ThemeMode.dark,
            billingDetails: billingDetails,
            merchantCountryCode: 'IN',
            merchantDisplayName: 'Refilled'),
      );
      displayPaymentSheet();
    } catch (e) {
      print("Exception .>>>>>> ${e.toString()}");
    }
  }

  displayPaymentSheet() async {
    try {

      await Stripe.instance.presentPaymentSheet();
       await Stripe.instance.confirmPaymentSheetPayment();

       paymentIntentData = null;
      Get.snackbar('Payment success', "Your payment is success");
    } on StripeException catch (e) {
      print("Exception=====> ${e.toString()}");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': '100',
        // amount charged will be specified when the method is called
        'currency': 'inr',
        // the currency
        'payment_method_types[]': 'card',
        // 'payment_method':'card',
        //'confirmation_method':'manual',
        // 'off_session':'false'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer $secret_key"
        },
      );

      print("response is ${response.statusCode}");
      return jsonDecode(response.body.toString());
    } catch (e) {
      print("Exception =>${e.toString()}");
    }
  }*/
