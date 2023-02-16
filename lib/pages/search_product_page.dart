import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/home_controller.dart';
import 'package:refilled_app/controllers/product_controller.dart';
import 'package:refilled_app/utils/global.dart';

class SearchProduct extends StatelessWidget {
  SearchProduct({Key? key}) : super(key: key);

  final _productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF061737),
                      )),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEEEFF0),
                          borderRadius: BorderRadius.circular(24)),
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFF061737),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, right: 16),
                            child: TextField(
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                  hintText: 'Search...',
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
                                    fontSize: 14,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent))),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  _productController.searchProducts.clear();
                                  Get.find<HomeController>()
                                      .getUserLocation();
                                } else {
                                  Get.find<HomeController>()
                                      .getUserLocation()
                                      .then((location) {
                                    if (location != null) {

                                      EasyDebounce.debounce(
                                          'my-debouncer',                 // <-- An ID for this particular debouncer
                                          Duration(milliseconds: 500),    // <-- The debounce duration
                                              () => _productController.searchProduct(
                                                  value, location)             // <-- The target method
                                      );




                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  )
                ],
              ),
              Obx(
                () => ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(bottom: 32.0),
                  shrinkWrap: true,
                  itemCount: _productController.searchProducts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: verticalListCell(index),
                      onTap: () {
                        _productController.onSearchProductClick(index);
                        Get.toNamed('product_detail');
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalListCell(index) {
    return Container(
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
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                  Global.getImageUrl(
                      _productController.searchProducts[index].productImg),
                  width: 100,
                  height: 100,
                )),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _productController.searchProducts[index].name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    _productController.searchProducts[index].description,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        color: Color(0xFF898989),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    Global.formatPrice(
                        _productController.searchProducts[index].price.toDouble()),
                    style: const TextStyle(
                        color: Color(0xFF29ABE2),
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.0),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
