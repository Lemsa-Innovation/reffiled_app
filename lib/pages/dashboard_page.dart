import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/address_controller.dart';
import 'package:refilled_app/controllers/cart_controller.dart';
import 'package:refilled_app/controllers/home_controller.dart';
import 'package:refilled_app/controllers/product_controller.dart';
import 'package:refilled_app/data/model/product_category_res_model.dart';
import 'package:refilled_app/data/model/product_res_model.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refilled_app/data/model/product_category_res_model.dart';

import '../utils/log.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ProductController _productController = Get.find<ProductController>();
  final _homeController = Get.find<HomeController>();
  final _cartController = Get.find<CartController>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    initLocation();
    _fetchAllProducts();
    load();

  }

  void initLocation() {
    Geolocator.getServiceStatusStream().listen((service) {
      if (service == ServiceStatus.enabled) {
        _homeController.getUserLocation().then(
          (value) {
            if (value != null && mounted) {
              _fetchProductCategories();
              _fetchPopularProducts();
              _fetchAllProducts();
            }
          },
        );
      }
    });
    _homeController.currentUserLocation.listen((p0) {
      if (p0 != null) {
        _fetchProductCategories();
        _fetchPopularProducts();
        _fetchAllProducts();
      }
    });
  }
  int get count => productsList.length;
  List productsList = [];
  int lastIndex = 0;
  int startingIndex = 4;

  void load() {
    print("load");
    setState(() {
      startingIndex = _productController.products.length < startingIndex+4 ? _productController.products.length : startingIndex+4;
    });
  }




  @override
  Widget build(BuildContext context) {
    if(_homeController.stillFetching.isFalse){
      return Scaffold(
          backgroundColor: Colors.white,
          body: CustomRefreshIndicator(
            trigger: IndicatorTrigger.trailingEdge,
            /// delegate with configuration
            builder: MaterialIndicatorDelegate(
              builder: (context, controller) {
                return const Icon(
                  Icons.auto_mode,
                  color: Colors.blue,
                  size: 30,
                );
              },
            ),
            onRefresh: _loadMore,
            child:
            _homeController.ordersStatus.value == true ?
            RefreshIndicator(
              key: _refreshIndicatorKey,

              color: Colors.white,
              backgroundColor: Colors.blue,
              onRefresh: () async {
                initLocation();
                _fetchAllProducts();
                load();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text('Get your goods',
                          style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text('Delivered!',
                          style: TextStyle(
                              color: Color(0xFF061737),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 40.0)),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text('Explore Categories',
                          style: TextStyle(
                              color: Color(0xFF061737),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0)),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        physics: const ScrollPhysics(),
                        itemCount: _productController.categories.length,
                        itemBuilder: (context, index) {
                          var item = _productController.categories[index];

                          return GestureDetector(
                              onTap: () {

                                for (int i = 0;
                                i < _productController.categories.length;
                                i++) {
                                  _productController.categories[i].isSelected =
                                      index == i;
                                }
                                var category = _productController.categories[index];

                                if(category.name == 'All'){
                                  _fetchAllProducts();
                                }else{
                                  _fetchProducts(
                                      category.id ?? 0, category.name ?? '');
                                }

                                // setState(() {
                                //
                                //
                                // });
                              },
                              child: _VerticalCategorie(
                                categoryImg: item.categoryImg ?? '',
                                isSelected: item.isSelected,
                                name: item.name,
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(_productController.selectedCategory,
                          style: const TextStyle(
                              color: Color(0xFF061737),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0)),
                    ),
                    Obx(() => _productController.isWorking.isTrue
                        ? const Center(
                        child: SpinKitFadingCube(
                          color: Color(0xFF239CCC),
                          size: 50.0,
                        )).paddingOnly(top: 20)
                        : _productController.products.isEmpty
                        ? Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/no_data.gif',
                              height: 200,
                            ),
                            const Text(
                                "No product available at your location in this moment!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF061737),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0))
                          ],
                        ))
                        : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0, right: 28.0, top:16, bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Expanded(
                                      child: Divider()
                                  ),

                                  Text('Popular Products',
                                      style: TextStyle(
                                          color: Color(0xFF01A1FF),
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18.0)),
                                  Expanded(
                                      child: Divider()
                                  ),

                                ],
                              ),
                            ),
                            ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 32.0),
                      shrinkWrap: true,
                      itemCount: _productController.products.length <=5 ?  _productController.products.length: startingIndex,
                      itemBuilder: (context, index) {
                            if(_productController.products[index].isPopular == 0 && _productController.products[index-1].isPopular == 1){
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 28.0, right: 28.0, top:16, bottom: 16),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                            child: Divider()
                                        ),

                                        Text('All Products',
                                            style: TextStyle(
                                                color: Color(0xFF01A1FF),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 18.0)),

                                        Expanded(
                                            child: Divider()
                                        ),

                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    child: _ProductItem(
                                        product: _productController.products[index]),
                                    onTap: () {
                                      _productController.onProductClick(index);
                                      Get.toNamed('product_detail');
                                    },
                                  )

                                ],
                              );
                            }
                            else{
                              return InkWell(
                                child: _ProductItem(
                                    product: _productController.products[index]),
                                onTap: () {
                                  _productController.onProductClick(index);
                                  Get.toNamed('product_detail');
                                },
                              );
                            }

                      },
                    ),
                          ],
                        ))
                  ],
                ),
              ),
            ) :
            Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/noorders.gif',
                      height: 500,
                    ),
                    const Text(
                        "Orders are not available for you in this moment!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF061737),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0)),
                    SizedBox(height: 10,),
                    const Text(
                        "Try again later!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF061737),
                            fontFamily: 'Montserrat',
                            fontSize: 16.0))

                  ],
                )),
          ));
    }else{
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
              child: Visibility(
                  visible: _homeController.stillFetching.value,
                  child: const SpinKitFadingCube(
                      color: Color(0xFF239CCC), size: 50.0))),
        ),
      );
    }

  }

  Future<bool> _loadMore() async {

    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 100));
    load();
    return true;
  }


  void _fetchProductCategories() async {
    var token =
        (await SharedPreferences.getInstance()).getString('user_token') ?? "";
    var result = await _productController.fetchProductCategories(
        token, _homeController.currentUserLocation.value);


    Category all = Category.fromJson(
      {
        "id": 0,
        "name": "All",
        "category_img": "all",
        "createdDtm": "2021-10-19T11:55:05.000Z",
        "isDeleted": 0,
        "warehouse_id": 0
      },
    );
    all.isSelected = true;

    result.insert(0, all);

    if (mounted) {
      setState(() {

        _productController.categories.addAll(result);
        _fetchAllProducts();

      });
    }
  }

  void _fetchPopularProducts() async {
    var token =
        (await SharedPreferences.getInstance()).getString('user_token') ?? "";
    var result = await _productController.fetchPopularProduct(token,
        userLocation: _homeController.currentUserLocation.value);
    if (mounted) {
      setState(() {
        _productController.products.addAll(result);
      });
    }
  }


  void _fetchAllProducts() async {
      var token =
          (await SharedPreferences.getInstance()).getString('user_token') ?? "";
      var result = await _productController.fetchAllProducts(token, _homeController.currentUserLocation.value);
      setState((){

       _productController.products.addAll(result);

      });
      await _loadMore();
     // _productController.products.addAll(result.sublist(5, result.length));

        }


void _fetchProducts(int categoryId, String categoryName) async {
    var token =
        (await SharedPreferences.getInstance()).getString('user_token') ?? "";
    var result = await _productController.fetchProducts(token, categoryId,
        categoryName, _homeController.currentUserLocation.value);

    setState(() {
      _productController.products.addAll(result);
    });
  }
}

class _VerticalCategorie extends StatelessWidget {
  final bool isSelected;
  final String categoryImg;
  final String? name;
  const _VerticalCategorie(
      {Key? key,
      required this.isSelected,
      required this.categoryImg,
      required this.name})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.grey[400]! : Colors.grey[100]!,
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
            ), //B
          ],
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFF239CCC)
                  : const Color(0xFFC9C9C9))),
      margin: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0x3329ABE2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(categoryImg == 'all')
                      Image.asset(
                        'assets/intro_2.png',
                        width: 42,
                        height: 42,
                        errorBuilder: (context, obj, stack) =>
                        const Icon(Icons.broken_image, color: Colors.black),
                      ),
                    if(categoryImg != 'all')
                      Image.network(
                      Global.getImageUrl(categoryImg),
                      width: 32,
                      height: 32,
                      errorBuilder: (context, obj, stack) =>
                          const Icon(Icons.broken_image, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF061737),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat'),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Global.getImageUrl(product.productImg),
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
                    product.name,
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
                    product.description,
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
                  if(product.discount != 0)
                    Text(
                      Global.formatPrice(product.price - (product.discount/100)*product.price),
                      style: const TextStyle(
                          color: Color(0xFF29ABE2),
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0),
                    ),
                  SizedBox(height: 5,),
                  if(product.discount != 0)
                  Text(
                    Global.formatPrice(product.price.toDouble()),
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationThickness:2,
                        decorationColor: Color(0xFF29ABE2),
                        color: Colors.red,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.0),
                  ),
                  if(product.discount == 0)
                    Text(
                      Global.formatPrice(product.price.toDouble()),
                      style: const TextStyle(
                          color: Color(0xFF29ABE2),
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
