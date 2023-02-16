import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/cart_controller.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:single_option_picker/single_option_picker.dart';

class Cart extends StatelessWidget {
  Cart({Key? key}) : super(key: key);
  final CartController _cartController = Get.put(CartController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    _cartController.getWalletBalance();
    _cartController.getMyCart();
    _cartController.isCouponApplied.value = false;

    /* if (showAppBar ?? false) {
      _cartController.getMyCart();
      Future.delayed(Duration(seconds: 1), () {});
    }*/

    return Scaffold(
      appBar: Get.arguments ?? false
          ? AppBar(
              elevation: 1,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: const Text(
                'CART',
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
            )
          : null,
      body: Stack(
        children: [
          RefreshIndicator(
            key: _refreshIndicatorKey,

            color: Colors.white,
            backgroundColor: Colors.blue,
            onRefresh: () async {
              _cartController.getWalletBalance();
              _cartController.getMyCart();
              _cartController.isCouponApplied.value = false;
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          return verticalListCell(index);
                        }),
                  ),
                  // const SizedBox(
                  //   height: 16.0,
                  // ),
                  // Obx(
                  //   () => _cartController.isCouponApplied.value
                  //       ? Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //           child: Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                   'Promo code ${_cartController.couponCode} applied',
                  //                   style: const TextStyle(
                  //                       color: Color(0xFF111719),
                  //                       fontWeight: FontWeight.w700,
                  //                       fontSize: 14,
                  //                       fontFamily: 'Montserrat'),
                  //                 ),
                  //               ),
                  //               IconButton(
                  //                 onPressed: () {
                  //                   _cartController.removeCouponCode();
                  //                 },
                  //                 icon: const Icon(
                  //                   Icons.close,
                  //                   color: Colors.red,
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         )
                  //       : Container(
                  //           padding:
                  //               const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  //           margin:
                  //               const EdgeInsets.only(left: 16.0, right: 16.0),
                  //           decoration: BoxDecoration(
                  //               shape: BoxShape.rectangle,
                  //               borderRadius: BorderRadius.circular(50),
                  //               border: const Border.fromBorderSide(BorderSide(
                  //                   width: 1.0, color: Color(0xFFEEEEEE)))),
                  //           child: Row(
                  //             children: [
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: TextField(
                  //                   controller: _cartController
                  //                       .promoCodeEditingController,
                  //                   decoration: const InputDecoration(
                  //                       border: InputBorder.none,
                  //                       hintText: 'Promo Code',
                  //                       hintStyle: TextStyle(
                  //                           color: Color(0xFFBEBEBE),
                  //                           fontWeight: FontWeight.w300,
                  //                           fontSize: 14,
                  //                           fontFamily: 'Montserrat')),
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 24.0,
                  //               ),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     FocusScope.of(context).unfocus();
                  //                     _cartController.applyCoupon();
                  //                   },
                  //                   style: ElevatedButton.styleFrom(
                  //                       padding: const EdgeInsets.fromLTRB(
                  //                           32.0, 12.0, 32.0, 12.0),
                  //                       primary: const Color(0xFF239CCC),
                  //                       shape: RoundedRectangleBorder(
                  //                           borderRadius:
                  //                               BorderRadius.circular(24.0))),
                  //                   child: const Text(
                  //                     'Apply',
                  //                     style: TextStyle(
                  //                         color: Colors.white,
                  //                         fontFamily: 'Montserrat',
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.w500),
                  //                   )),
                  //             ],
                  //           ),
                  //         ),
                  // ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          _cartController.walletAmount.value > 0 ? true : false,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            border: const Border.fromBorderSide(
                                BorderSide(color: Color(0xFFE0E0E0), width: 1)),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Use wallet amount?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    Global.formatPrice(
                                        _cartController.walletAmount.value.toDouble()),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                  child: Checkbox(
                                      activeColor: const Color(0xFF29ABE2),
                                      splashRadius: 50,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      value:
                                          _cartController.isUseWalletAmount.value,
                                      onChanged: (bool? isChecked) {
                                        if (isChecked != null) {
                                          _cartController
                                              .setUseWalletAmount(isChecked);
                                        }
                                      }),
                                ),
                              ],
                            ),
                            Obx(
                              () => Text(
                                _cartController.isUseWalletAmount.value
                                    ? '${Global.formatPrice(_cartController.usedWalletAmount.value.toDouble())} is applied on this order!'
                                    : 'You can only use 50% of your billing amount!',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(
                      'Choose Delivery ',
                      style: TextStyle(
                          color: Color(0xFF061737),
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Obx(
                    () => SingleOptionPicker(
                      numberOfOptions: 2,
                      optionBuilder: (index, isSelected) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : const Color.fromARGB(88, 103, 124, 64)),
                                gradient: LinearGradient(
                                    colors: isSelected
                                        ? [
                                            const Color(0xFF0EE2F5),
                                            const Color(0xFF29ABE2)
                                          ]
                                        : [Colors.white, Colors.white]),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              children: [
                                Text(
                                  _cartController.deliveryOptions[index].price,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF59677C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat'),
                                ),
                                Text(
                                  _cartController
                                      .deliveryOptions[index].deliveryTime,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF59677C),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.0,
                                      fontFamily: 'Montserrat'),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      onChangeOption: (index) {
                        _cartController.selectDeliveryType(index);
                      },
                      selectedOptionIndex: _cartController.deliveryType.value,
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        Obx(
                          () => Text(
                            '\$${_cartController.subTotal}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 16,
                    indent: 16.0,
                    endIndent: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'State Tax Fee',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        Obx(
                          () => Text(
                            '\$${_cartController.stateFee.value}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 16,
                    indent: 16.0,
                    endIndent: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Obx(
                          () => Text(
                            _cartController
                                .deliveryOptions[
                                    _cartController.deliveryType.value]
                                .deliveryTime,
                            style: const TextStyle(
                                color: Color(0xFFBEBEBE),
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 1,
                          child: Obx(
                            () => Text(
                              '\$${_cartController.deliveryPrice[_cartController.deliveryType.value]}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 16,
                    indent: 16.0,
                    endIndent: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Driver Benefits Fee',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // Obx(
                        //       () => Text(
                        //     _cartController
                        //         .deliveryOptions[
                        //     _cartController.deliveryType.value]
                        //         .deliveryTime,
                        //     style: const TextStyle(
                        //         color: Color(0xFFBEBEBE),
                        //         fontFamily: 'DMSans',
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 13.0),
                        //   ),
                        // ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 1,
                          child: Obx(
                                () => Text(
                              '\$${_cartController.driverBenefitsFee}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 16,
                    indent: 16.0,
                    endIndent: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Obx(
                          () => Text(
                            '(${_cartController.totalItemsInCart} items)',
                            style: const TextStyle(
                                color: Color(0xFFBEBEBE),
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 1,
                          child: Obx(
                            () => Text(
                              '\$${_cartController.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 16, indent: 16.0, endIndent: 16.0),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _cartController.clearCart();
                      },
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 1.5,
                                  offset: const Offset(-4, 4))
                            ],
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 245, 14, 14),
                              Color.fromARGB(255, 226, 41, 41)
                            ])),
                        child: const Center(
                          child: Text(
                            'Clear CART',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if(_cartController.ordersStatus.isTrue)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                          Navigator.pushNamed(context, '/checkout');
                      },
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 1.5,
                                  offset: const Offset(-4, 4))
                            ],
                            gradient: const LinearGradient(
                                colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
                        child: const Center(
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(_cartController.ordersStatus.isFalse)
                    Center(
                        child: Column(
                          children: const [
                            Text(
                                "You can't checkout! Orders are not available for you in this moment!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF061737),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0)),
                            SizedBox(height: 10,),
                            Text(
                                "Try again later!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF061737),
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.0))

                          ],
                        ))

                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: _cartController.cartItems.isEmpty ? true : false,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: const Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Looks like your bag is empty.\n\nStart adding items!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: _cartController.showProgress.value ? true : false,
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

  Widget verticalListCell(index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Card(
                  elevation: 0.2,
                  color: Colors.white,
                  shadowColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network(
                        Global.getImageUrl(
                            _cartController.cartItems[index].productImg),
                      )))),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _cartController.cartItems[index].productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _cartController.deleteItemFromCart(index);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      iconSize: 18,
                      padding: const EdgeInsets.all(0),
                    )
                  ],
                ),
                Text(
                  _cartController.cartItems[index].productDesc,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                      color: Color(0xFF898989),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        '\$${_cartController.cartItems[index].price}',
                        style: const TextStyle(
                            color: Color(0xFF29ABE2),
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _cartController.removeItemQuantity(index);
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Color(0xFF29ABE2),
                            )),
                        Text(
                          _cartController.cartItems[index].quantity.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                              fontFamily: 'DMSans'),
                        ),
                        IconButton(
                            onPressed: () {
                              _cartController.addItemQuantity(index);
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFF29ABE2),
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
