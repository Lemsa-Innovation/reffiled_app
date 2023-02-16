import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/cart_controller.dart';
import 'package:refilled_app/controllers/orders_controller.dart';
import 'package:refilled_app/utils/global.dart';

class PastOrders extends StatelessWidget {
  PastOrders({Key? key}) : super(key: key);

  final OrdersController _ordersController = Get.put(OrdersController());
  final CartController _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(
            () => ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _ordersController.pastOrders.length,
                itemBuilder: (context, index) {
                  return pastOrderCell(index);
                }),
          ),
          Obx(
            () => Visibility(
              visible: _ordersController.pastOrders.isEmpty,
              child: const Center(
                  child: Text(
                'No Past orders',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              )),
            ),
          ),
          Obx(
            () => Visibility(
              visible: _ordersController.showProgress.value,
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

  Widget pastOrderCell(index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/order_detail', arguments: {
          'order_id': _ordersController.pastOrders[index].orderId.toString()
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100]!,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ), //BoxShadow
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //
              ]),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[100]!,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                            ), //BoxShadow
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //
                          ]),
                      child: Image.network(
                        Global.getImageUrl(
                            _ordersController.pastOrders[index].productImg),
                        width: 42,
                        height: 42,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  'Order ID: ${_ordersController.pastOrders[index].orderId}',
                                  style: const TextStyle(
                                      color: Color(0xFF29ABE2),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Text(
                                  Global.formatPrice(_ordersController
                                      .pastOrders[index].price.toDouble()),
                                  style: const TextStyle(
                                      color: Color(0xFF29ABE2),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            _ordersController.pastOrders[index].productName,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                color: Color(0xFF061737),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat'),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            _ordersController.pastOrders[index].productDesc,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                color: Color(0xFF898989),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DMSans'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Color(_ordersController
                                  .pastOrders[index].orderStatus
                                  .toLowerCase() ==
                              'cancelled'
                          ? 0xFFD14444
                          : 0xFF4EE476),
                      size: 10,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Order ${_ordersController.pastOrders[index].orderStatus}',
                        style: TextStyle(
                            color: Color(_ordersController
                                        .pastOrders[index].orderStatus
                                        .toLowerCase() ==
                                    'cancelled'
                                ? 0xFFD14444
                                : 0xFF4EE476),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _cartController.addProductToCart(
                              _ordersController.pastOrders[index].productId);
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            elevation: MaterialStateProperty.all(1),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all(Colors.grey[100]),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)))),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF0EE2F5),
                                Color(0xFF29ABE2)
                              ])),
                          child: const Center(
                            child: Text(
                              'Re - Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
