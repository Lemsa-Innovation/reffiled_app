import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/address_controller.dart';
import 'package:refilled_app/controllers/cart_controller.dart';
import 'package:refilled_app/controllers/checkout_controller.dart';
import 'package:refilled_app/controllers/payment_method_controller.dart';
import 'package:pay/pay.dart';

var newAmount = '0'.obs;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CheckoutController _checkoutController = Get.put(CheckoutController());
  final AddressController _addressController = Get.put(AddressController());
  final PaymentMethodController _paymentMethodController =
      Get.put(PaymentMethodController());

  // final _paymentItems = [
  //    PaymentItem(
  //     label: 'Total',
  //     amount: newAmount.value,
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    log('this is an result');
    debugPrint(paymentResult.toString());
  }

  @override
  void initState() {
    super.initState();
    newAmount.value = _checkoutController.amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: newAmount.value,
        status: PaymentItemStatus.final_price,
      )
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'CHECKOUT',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xFF061737),
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Deliver To',
                    style: TextStyle(
                        color: Color(0xFF061737),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => _checkoutController.addressId.value.isEmpty
                        ? Center(
                            child: TextButton.icon(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 32)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            side: const BorderSide(
                                                color: Color(0xFF29ABE2),
                                                width: 1.0)))),
                                onPressed: () async {
                                  _addressController.initCurrentPosition();
                                  Get.toNamed('/add_address',
                                      arguments: {'is_picking_address': true});
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF29ABE2),
                                ),
                                label: const Text(
                                  'Add Address',
                                  style: TextStyle(
                                      color: Color(0xFF29ABE2),
                                      fontFamily: 'Montserrat',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                )),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/img_map.png',
                                    ),
                                    Center(
                                      child: Image.asset(
                                        'assets/img_marker.png',
                                        height: 70,
                                        width: 70,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      child: Text(
                                        _checkoutController.addressTag.value,
                                        style: const TextStyle(
                                            color: Color(0xFF061737),
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0),
                                      ),
                                      visible: true,
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      _checkoutController
                                          .addressDescription.value,
                                      style: const TextStyle(
                                          color: Color(0xFF4E5A5F),
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.0),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed('/address_list',
                                      arguments: {'is_picking_address': true});
                                },
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                      color: Color(0xFF29ABE2),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat'),
                                ),
                              )
                            ],
                          ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                        color: Color(0xFF061737),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 16.0),
                  GooglePayButton(
                    paymentConfigurationAsset: 'gpay.json',
                    paymentItems: _paymentItems,
                    //style: GooglePayButtonStyle.white,
                    type: GooglePayButtonType.pay,
                    height: 70,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  ApplePayButton(
                    onPressed: () {
                      newAmount.value =
                          _checkoutController.amount.toStringAsFixed(2);
                      // if (_checkoutController.addressId.isEmpty) {
                      //   Get.snackbar(
                      //       'Delivery Address Missing', 'Please Enter Your Delivery Address');
                      //   return;
                      // }
                    },
                    paymentConfigurationAsset: 'applepay.json',
                    paymentItems: _paymentItems,
                    style: ApplePayButtonStyle.whiteOutline,
                    type: ApplePayButtonType.plain,
                    height: 65,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20.0),
                    onPaymentResult: (value) {
                      log('$value');
                    },
                    onError: (error) {
                      log('apple pay payment error $error');
                    },
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  // Visibility(
                  //   visible: true,
                  //   child: InkWell(
                  //     onTap: () async{
                  //      _paymentMethodController.payUsingGooglePay();
                  //   //  await  _paymentMethodController.initPaymentSheet();
                  //
                  //     },
                  //     child: Container(
                  //       width: double.infinity,
                  //       height: 84,
                  //       padding: EdgeInsets.all(24),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(24),
                  //           border: Border.fromBorderSide(
                  //               BorderSide(color: Color(0x8AE0E0E0), width: 1.0))),
                  //       child: Image.asset(
                  //         'assets/img_google_pay.png',
                  //         height: 50,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  // Visibility(
                  //   visible: false,
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 84,
                  //     padding: const EdgeInsets.all(24),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(24),
                  //         border: const Border.fromBorderSide(BorderSide(
                  //             color: Color(0x8AE0E0E0), width: 1.0))),
                  //     child: Image.asset(
                  //       'assets/img_venmo.png',
                  //       height: 50,
                  //     ),
                  //   ),
                  // ),
                  Obx(
                    () => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _paymentMethodController.cards.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                var cardData = _paymentMethodController
                                    .getSelectedCardData(index);
                                _checkoutController.selectedCard = cardData;
                                log("card id is = $cardData");
                              },
                              child: paymentMethodCell(index));
                        }),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Visibility(
                      visible: _paymentMethodController.isShowAddCard.value,
                      child: Container(
                        width: double.infinity,
                        height: 84,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FC),
                            borderRadius: BorderRadius.circular(24)),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed('/add_card');
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 38.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xFFF7F7F7),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFF061737),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Text(
                                'Add New Card',
                                style: TextStyle(
                                    color: Color(0xFF061737),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(32),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            //Navigator.pushNamed(context, '/confirm_order');
                            _checkoutController.validateOrderData();
                          },
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32)))),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF0EE2F5),
                                  Color(0xFF29ABE2)
                                ])),
                            child: Column(
                              children: [
                                const Text(
                                  'Confirm Order',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Obx(
                                  () => Text(
                                    'Total pay \$${Get.find<CartController>().total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: _checkoutController.showProgress.value,
              child: const Center(
                  child: SpinKitFadingCube(
                color: Color(0xFF239CCC),
                size: 50.0,
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget paymentMethodCell(index) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        height: 84,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: const Border.fromBorderSide(
                BorderSide(color: Color(0x8AE0E0E0), width: 1.0))),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ic_master_card.png',
                height: 20,
              ),
              const SizedBox(
                width: 16,
              ),
              const Text(
                '**** **** ****',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins"),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  _paymentMethodController.cards[index].cardNumber
                      .split(' ')
                      .last,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Poppins"),
                ),
              ),
              Obx(
                () => Visibility(
                    visible:
                        _paymentMethodController.cards[index].isSelected.value,
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.lightGreenAccent,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
