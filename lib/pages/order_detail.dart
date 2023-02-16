import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/order_detail_controller.dart';
import 'package:refilled_app/utils/global.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final _ordersDetailController = Get.put(OrderDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Order Details',
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
      body: Obx(
        () => _ordersDetailController.showProgress.value
            ? const Center(
                child: SpinKitFadingCube(
                color: Color(0xFF239CCC),
                size: 50.0,
              ))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Your Order',
                              style: TextStyle(
                                color: Color(0xFF061737),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            color: Color(_ordersDetailController.orderStatus
                                        .toLowerCase() ==
                                    'cancelled'
                                ? 0xFFD14444
                                : 0xFF4EE476),
                            size: 10,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Order ${_ordersDetailController.orderStatus}',
                            style: TextStyle(
                                color: Color(_ordersDetailController.orderStatus
                                            .toLowerCase() ==
                                        'cancelled'
                                    ? 0xFFD14444
                                    : 0xFF4EE476),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            _ordersDetailController.orderedProducts.length,
                        itemBuilder: (context, index) {
                          return orderItemCell(index);
                        }),
                    const Divider(height: 60, color: Color(0x1A000000)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
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
                          Text(
                            _ordersDetailController.subTotal.value,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 16,
                      color: Color(0x1A000000),
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
                            'Tax and Fees',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                          ),
                          Text(
                            _ordersDetailController.taxFee.value,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 16,
                      color: Color(0x1A000000),
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
                          Text(
                            '(${_ordersDetailController.deliveryTime.value})',
                            style: const TextStyle(
                                color: Color(0xFFBEBEBE),
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _ordersDetailController.deliveryAmount.value,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          _ordersDetailController.promoAmount.value == "\$0.00"
                              ? false
                              : true,
                      child: const Divider(
                        height: 16,
                        color: Color(0x1A000000),
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                    ),
                    Visibility(
                      visible:
                          _ordersDetailController.promoAmount.value == "\$0.00"
                              ? false
                              : true,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Promo Amount',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '-${_ordersDetailController.promoAmount.value}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19.0,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 16,
                      color: Color(0x1A000000),
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
                          Text(
                            '(${_ordersDetailController.orderedProducts.length} items)',
                            style: const TextStyle(
                                color: Color(0xFFBEBEBE),
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _ordersDetailController.totalAmount.value,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 16,
                      color: Color(0x1A000000),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ORDER NUMBER',
                        style: TextStyle(
                            color: Color(0x59677CBF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Order ID: ${_ordersDetailController.currentOrderId}',
                        style: const TextStyle(
                            color: Color(0xFF59677C),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'PAYMENT',
                        style: TextStyle(
                            color: Color(0x59677CBF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Using ${_ordersDetailController.paymentBy} ending with ${_ordersDetailController.cardLast4}',
                        style: const TextStyle(
                            color: Color(0xFF59677C),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'DATE',
                        style: TextStyle(
                            color: Color(0x59677CBF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${_ordersDetailController.orderDate} at ${_ordersDetailController.orderTime}',
                        style: const TextStyle(
                            color: Color(0xFF59677C),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'DELIVERY ADDRESS',
                        style: TextStyle(
                            color: Color(0x59677CBF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _ordersDetailController.deliveryAddress.value,
                        style: const TextStyle(
                            color: Color(0xFF59677C),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 32),
                      child: ElevatedButton(
                          onPressed: () {
                            _ordersDetailController.viewInvoiceInBrowser();
                          },
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ))),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF0EE2F5),
                                  Color(0xFF29ABE2)
                                ])),
                            child: const Center(
                              child: Text(
                                'View Invoice',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget orderItemCell(index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
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
                          color: Colors.grey[200]!,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ), //BoxShadow
                        const BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //
                      ]),
                  child: Image.network(
                    Global.getImageUrl(_ordersDetailController
                        .orderedProducts[index].productImg),
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
                        _ordersDetailController
                            .orderedProducts[index].productName,
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
                        _ordersDetailController
                            .orderedProducts[index].productDesc,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                            color: Color(0xFF898989),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'DMSans'),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Qty ${_ordersDetailController.orderedProducts[index].quantity}  x ${Global.formatPrice(_ordersDetailController.orderedProducts[index].price.toDouble())}',
                            style: const TextStyle(
                                color: Color(0xFFA1A1A1),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto'),
                          ),
                          Text(
                            Global.formatPrice(_ordersDetailController
                                .orderedProducts[index].price.toDouble()),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: Color(0xFF29ABE2),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Roboto'),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
