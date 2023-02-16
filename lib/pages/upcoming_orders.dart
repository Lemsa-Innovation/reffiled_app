import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/orders_controller.dart';
import 'package:refilled_app/utils/global.dart';

class UpcomingOrders extends StatelessWidget {
  final OrdersController _orderController = Get.put(OrdersController());

  UpcomingOrders({Key? key}) : super(key: key);

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
                itemCount: _orderController.upcomingOrders.length,
                itemBuilder: (context, index) {
                  return upcomingOrderCell(index);
                }),
          ),
          Obx(
            () => Visibility(
              visible: _orderController.upcomingOrders.isEmpty,
              child: const Center(
                  child: Text(
                'No Upcoming orders',
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
              visible: _orderController.showProgress.value,
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

  Widget upcomingOrderCell(index) {
    return Container(
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
                          _orderController.upcomingOrders[index].productImg),
                      width: 42,
                      height: 42,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: #${_orderController.upcomingOrders[index].orderId}',
                          style: const TextStyle(
                              color: Color(0xFF29ABE2),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto'),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _orderController.upcomingOrders[index].productName,
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
                          _orderController.upcomingOrders[index].productDesc,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Estimated Arrival',
                      style: TextStyle(
                          color: Color(0xFF9796A1),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'Now',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Color(0xFF9796A1),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Food on the way',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Color(0xFF111719),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Obx(
                    () => Text(
                      _orderController.upcomingOrders[index].deliveryTime
                          .split(' ')
                          .first,
                      style: const TextStyle(
                          color: Color(0xFF111719),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          fontSize: 39.27),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'min',
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: Color(0xFF111719),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showAlert(index);
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14)),
                          elevation: MaterialStateProperty.all(1),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all(Colors.grey[100]),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)))),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color(0xFF111719),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/track_order', arguments: {
                          'order_id': _orderController
                              .upcomingOrders[index].orderId
                              .toString()
                        });
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
                            'Track Order',
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
    );
  }

  void showAlert(index) {
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
        middleText: "Are you sure you want to cancel this order",
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
              child: Text("No",
                  style: TextStyle(
                      color: Color(0xFF29ABE2),
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
            )),
        confirm: ElevatedButton(
            onPressed: () {
              Get.back();
              _orderController.cancelOrder(index);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD14444)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Yes',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )));
  }
}
