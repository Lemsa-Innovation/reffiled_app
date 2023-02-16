import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:refilled_app/data/model/cards_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:refilled_app/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodController extends GetxController {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  var cards = <MyCard>[].obs;
  var isShowAddCard = false.obs;
  var showProgress = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCards();
  }

  void onCreditCardModelChanged(CreditCardModel model) {
    cardNumber = model.cardNumber;
    cardHolderName = model.cardHolderName;
    expiryDate = model.expiryDate;
    cvvCode = model.cvvCode;
  }

  void getCards() async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? "";
    var result = await RemoteServices.getCards(token);

    if (result != null) {
      if (result.success) {
        isShowAddCard.value = result.data.length < 5;
        cards.clear();
        cards.addAll(result.data);
      } else {
        Get.snackbar("Error", result.message);
      }
      showProgress.value = false;
    }
  }

  void addNewCard() async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? "";
    var result = await RemoteServices.addNewCard(
        token, cardHolderName, cardNumber, expiryDate);
    if (result != null) {
      if (result.success) {
        getCards();
        Get.back();
      } else {
        Get.snackbar("Error", result.message);
      }
    }
    showProgress.value = false;
  }

  void deleteCard(index) async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? "";
    var cardId = cards[index].id;

    var result = await RemoteServices.deleteCard(token, cardId);

    if (result != null) {
      if (result.success) {
        getCards();
      } else {
        Get.snackbar('Error', result.message);
      }
    }

    showProgress.value = false;
  }

  MyCard getSelectedCardData(index) {
    for (int i = 0; i < cards.length; i++) {
      cards[i].isSelected.value = index == i;
    }

    return cards[index];
  }

  void payUsingGooglePay() async {
    try {
      await Stripe.instance.initGooglePay(const GooglePayInitParams(
          testEnv: true, merchantName: 'Refilled', countryCode: 'us'));

      await Stripe.instance.presentGooglePay(const PresentGooglePayParams(
          clientSecret:
              "pi_3KEqj9IJNoCzoXWK0gxrsCXC_secret_vJViK9uD126YrMfJIXATVeGmi"));

      Get.snackbar("Success", "Google Pay payment succesfully completed");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      // final data = await _createTestPaymentSheet();

      // create some billingdetails
      const billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '140301',
        ),
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: const SetupPaymentSheetParameters(
          paymentIntentClientSecret:
              "pi_3KEqj9IJNoCzoXWK0gxrsCXC_secret_vJViK9uD126YrMfJIXATVeGmi",
          merchantDisplayName: 'Flutter Stripe Store Demo',
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          primaryButtonColor: Colors.redAccent,
          billingDetails: billingDetails,
          testEnv: true,
          merchantCountryCode: 'US',
        ),
      );
      await confirmPayment();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Get.snackbar("Success", "Payment completed");
    } on Exception catch (e) {
      if (e is StripeException) {
        Log.verbose("Error from Stripe: = ${e.error.localizedMessage}");
        Get.snackbar(
            "Error", " Error from Stripe: ${e.error.localizedMessage}");
      } else {
        Get.snackbar("Error", "Unforeseen error: $e");
      }
    }
  }

  void showDeleteCardAlert(index) {
    Get.defaultDialog(
        radius: 8,
        contentPadding: const EdgeInsets.all(8),
        barrierDismissible: false,
        title: "Alert",
        titleStyle: const TextStyle(
            color: Color(0xFF061737),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 16),
        middleText:
            "Are you sure you want to delete this Card permanently from your Payment methods list? ",
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
              deleteCard(index);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD14444)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                "Delete",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )));
  }
}
