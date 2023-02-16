import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/product_controller.dart';
import 'package:refilled_app/utils/global.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key}) : super(key: key);
  final ProductController _productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Obx(
                      () => Container(
                        margin: EdgeInsets.only(
                            bottom: _productController.mQuantity.value > 0
                                ? 100
                                : 0),
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0x3329ABE2),
                                ),
                                height: 250,
                                width: 250,
                                child: Image.network(
                                  Global.getImageUrl(
                                      _productController.productImage.value),
                                  height: 200,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 26,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                               if (_productController.productStoreImage.value == '')
                                CircleAvatar(
                                  radius: 30.0,

                                  backgroundImage:
                                  AssetImage("assets/imgNotFound.png"),
                                  backgroundColor: Colors.transparent,
                                ),

                                if (_productController.productStoreImage.value != '')
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage:
                                  NetworkImage(Global.getImageUrl(_productController.productStoreImage.value)),
                                  backgroundColor: Colors.transparent,
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    Text(
                                      _productController.productStoreName.value,
                                      style: const TextStyle(
                                          color: Color(0xFF061737),
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Montserrat'),
                                    ),

                                    Text(
    _productController.productStoreDesc.value,
                                          style: const TextStyle(
                                          color: Color(0xFF061737),
                                          letterSpacing: 1.0,
                                          height: 2,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Montserrat'),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.1),),
                            const SizedBox(
                              height: 26,
                            ),

                            Text(
                              _productController.productName.value,
                              style: const TextStyle(
                                  color: Color(0x80061737),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat'),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _productController
                                        .productCategoryName.value,
                                    style: const TextStyle(
                                        color: Color(0xFF061737),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                                if(_productController.productDiscount.value != 0)
                                Text(
                                  Global.formatPrice(
                                      ( _productController.mItemPrice.value-(_productController.productDiscount.value/100) * _productController.mItemPrice.value)),
                                  style: const TextStyle(
                                      color: Color(0xFF29ABE2),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat'),
                                ),
                                SizedBox(width: 5,),
                                if(_productController.productDiscount.value != 0)
                                  Text(
                                  Global.formatPrice(
                                      _productController.mItemPrice.value.toDouble()),

                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness:2,
                                      decorationColor: Color(0xFF29ABE2),
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat'),
                                ),

                                if(_productController.productDiscount.value == 0)
                                  Text(
    Global.formatPrice(
    _productController.mItemPrice.value.toDouble()),
                                    style: const TextStyle(
                                        color: Color(0xFF29ABE2),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              _productController.productDescription.value,
                              style: const TextStyle(
                                  color: Color(0xFF061737),
                                  letterSpacing: 1.0,
                                  height: 2,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat'),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: _productController.mQuantity.value == 0
                                  ? ElevatedButton(
                                      onPressed: () {
                                        _productController
                                            .addToCartWithQuantity();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 70),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF0EE2F5),
                                                  Color(0xFF29ABE2)
                                                ])),
                                        child: const Text(
                                          'Add ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Montserrat"),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: const Border.fromBorderSide(
                                            BorderSide(
                                                color: Color(0x1A000000),
                                                width: 1.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _productController
                                                    .removeFromCartWithQuantity();
                                              },
                                              icon: const Icon(Icons.remove)),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Obx(
                                            () => Text(
                                              _productController.mQuantity.value
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                _productController
                                                    .addToCartWithQuantity();
                                              },
                                              icon: const Icon(Icons.add)),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 32,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => AnimatedContainer(
                    height: _productController.mQuantity > 0 ? 80 : 0,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)),
                        color: Color(0xFF239CCC)),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(34.0, 16.0, 34.0, 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Price',
                                    style: TextStyle(
                                        color: Color(0xB3FFFFFF),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  Obx(
                                    () => Text(
                                      Global.formatPrice((_productController
                                              .mItemPrice.value *
                                          _productController.mQuantity.value).toDouble()),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'DMSans'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24))),
                                onPressed: () async {
                                  Get.offNamed('/cart', arguments: true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: const Text(
                                    'GO TO CART',
                                    style: TextStyle(color: Color(0xFF29ABE2)),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Obx(
              () => Visibility(
                visible: _productController.showProgress.value,
                child: const Center(
                    child: SpinKitFadingCube(
                  color: Color(0xFF239CCC),
                  size: 50.0,
                )),
              ),
            )
          ],
        ));
  }
}
