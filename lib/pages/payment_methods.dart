import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:refilled_app/controllers/payment_method_controller.dart';

class PaymentMethods extends StatelessWidget {
  PaymentMethods({Key? key}) : super(key: key);

  final _paymentMethodController = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'PAYMENT METHODS',
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
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 16.0,
                ),
                Visibility(
                  visible: false,
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.grey[100],
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Image.asset(
                                        "assets/paypal.png",
                                        height: 37.0,
                                        width: 32.0,
                                      )),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/ic_bin.png',
                                    height: 20,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/ic_edit.png',
                                    height: 18,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Text(
                            'Paypal email',
                            style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat"),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text(
                            'maria@gmail.com',
                            style: TextStyle(
                                color: Color(0xFF090909),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Obx(
                  () => Visibility(
                    visible: _paymentMethodController.isShowAddCard.value,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/add_card');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 84,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                            color: const Color(0x1A29ABE2),
                            borderRadius: BorderRadius.circular(24)),
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
                const SizedBox(
                  height: 24.0,
                ),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: _paymentMethodController.cards.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return addedCardCell(index);
                      }),
                )
              ],
            ),
          ),
          Obx(
            () => Visibility(
              visible: _paymentMethodController.showProgress.value,
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

  Widget addedCardCell(index) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Container(
        width: double.infinity,
        height: 84,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
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
              IconButton(
                  onPressed: () {
                    _paymentMethodController.showDeleteCardAlert(index);
                  },
                  icon: Image.asset(
                    'assets/ic_bin.png',
                    height: 18,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
