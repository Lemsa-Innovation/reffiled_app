import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/cart_controller.dart';
import 'package:refilled_app/controllers/home_controller.dart';
import 'package:refilled_app/controllers/profile_controller.dart';
import 'package:refilled_app/pages/dashboard_page.dart';
import 'package:refilled_app/services/notification_service.dart';
import 'package:refilled_app/utils/global.dart';
import 'dart:io' show Platform;

import 'cart_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _homeController = Get.put(HomeController());
  final _cartController = Get.put(CartController());
  final _profileController = Get.put(ProfileController());
  final _advancedDrawerController = AdvancedDrawerController();

  int _bottomSelectedIndex = 0;

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  void pageChanged(index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  void bottomTab(index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    super.initState();
    generateToken();
    _profileController.onInit();
    initFirbease();
  }

  void initFirbease() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        NotificationController().showNotification(
            notification.hashCode, notification.title, notification.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Get.defaultDialog(
            title: notification.title ?? '',
            middleText: notification.body ?? '');
      }
    });
  }

  void generateToken() async {
    var messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      await messaging.requestPermission();
    }
    messaging.getToken().then((value) {
      _homeController.updateFcmToken(value ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return AdvancedDrawer(
      backdropColor: const Color(0xFFE5E5E5),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: _bottomSelectedIndex == 0 ? 0.0 : 4.0,
          title: _bottomSelectedIndex == 0
              ? GestureDetector(
                  onTap: _homeController.searchAddress,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset('assets/ic_location_home.png', width: 18),
                      const SizedBox(width: 8),
                      Obx(() => Expanded(
                            flex: _homeController.address.value ==
                                    'Permission Denied\nclick here to set address Manually'
                                ? 1
                                : 0,
                            child: Text(
                              _homeController.address.value.length> 42 ? _homeController.address.value.substring(0,42)+'...' : _homeController.address.value,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color(0xFF061737),
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: (){
                          Get.toNamed('/wallet');

                        },
                        child: Image.asset(
                          'assets/ic_wallet.png',
                          width: 28,
                          color: Color(0xFF239CCC),
                        ),
                      ),
                      const SizedBox(width: 8),

                    ],
                  ),
                )
              : const Text(
                  'CART',
                  style: TextStyle(
                      color: Color(0xFF061737),
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                ),
          centerTitle: true,
          leading: _bottomSelectedIndex == 0
              ? IconButton(
                  onPressed: _advancedDrawerController.showDrawer,
                  icon: Image.asset(
                    'assets/drawer.png',
                    width: 24,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: [const Dashboard(), Cart()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/search_product');
          },
          backgroundColor: const Color(0xFF239CCC),
          child: const Icon(Icons.search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Material(
          shadowColor: Colors.grey[100],
          elevation: 8.0,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              child: Obx(
                () => BottomNavigationBar(
                  enableFeedback: true,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  backgroundColor: Colors.white,
                  iconSize: 32,
                  currentIndex: _bottomSelectedIndex,
                  onTap: bottomTab,
                  items: [
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Image.asset(
                            'assets/ic_home.png',
                            height: 32,
                          ),
                        ),
                        label: '',
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Image.asset(
                            'assets/ic_home_active.png',
                            height: 32,
                          ),
                        )),
                    BottomNavigationBarItem(
                      icon: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Image.asset(
                              'assets/ic_cart.png',
                              height: 32,
                            ),
                          ),
                          Visibility(
                            visible: _cartController.totalItemsInCart.value > 0
                                ? true
                                : false,
                            child: Material(
                              color: Colors.transparent,
                              elevation: 4.0,
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD14444),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Text(
                                    _cartController.totalItemsInCart.value
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                        fontSize: 8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: '',
                      activeIcon: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Image.asset(
                              'assets/ic_cart_active.png',
                              height: 32,
                            ),
                          ),
                          Visibility(
                            visible: _cartController.totalItemsInCart.value > 0
                                ? true
                                : false,
                            child: Material(
                              color: Colors.transparent,
                              elevation: 4.0,
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD14444),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Text(
                                    _cartController.totalItemsInCart.value
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                        fontSize: 8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        drawerEnableOpenDragGesture: false,
      ),
      drawer: AppDrawer(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final _advancedDrawerController = AdvancedDrawerController();
  final _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return Text(
                                  _profileController.currentUser?.name ?? '',
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19.0,
                                      color: Color(0xFF000000)),
                                );
                              }),
                            ),
                            Visibility(
                              visible: false,
                              child: IconButton(
                                  onPressed: () {
                                    _advancedDrawerController.hideDrawer();
                                    Get.toNamed('/my_qr_code');
                                  },
                                  icon: const Icon(Icons.qr_code_2)),
                            )
                          ],
                        ),
                        Obx(() {
                          return Text(
                            _profileController.currentUser?.email ?? '',
                            style: const TextStyle(
                              color: Color(0xFF9EA1B1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_document.png',
                      width: 24,
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Get.toNamed('/my_orders');

                      // _advancedDrawerController.hideDrawer();
                    },
                    title: const Text(
                      'My Orders',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_profile.png',
                      width: 24.0,
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Get.toNamed('/profile');
                    },
                    title: const Text(
                      'My Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_location.png',
                      width: 24,
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Get.toNamed('/address_list');
                    },
                    title: const Text(
                      'Delivery Address',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_payment.png',
                      width: 24.0,
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Get.toNamed('/payment_methods');
                    },
                    title: const Text(
                      'Payment Methods',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_wallet.png',
                      width: 24,
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Get.toNamed('/wallet');
                    },
                    title: const Text(
                      'Wallet',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_settings.png',
                      width: 24,
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Get.toNamed('/invite_friends');
                    },
                    title: const Text(
                      'Invite friends',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  /* ListTile(
                      leading: Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      onTap: () {},
                      title: const Text(
                        'Contact Us',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),*/
                  ListTile(
                    leading: Image.asset(
                      'assets/ic_help.png',
                      width: 24.0,
                    ),
                    onTap: () async {
                      _advancedDrawerController.hideDrawer();
                      Global.launchUrl("$url/support/home");
                    },
                    title: const Text(
                      'Help & FAQs',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: InkWell(
              onTap: () async {
                _advancedDrawerController.hideDrawer();
                Get.find<HomeController>().showLogoutAlert();
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/ic_logout.png',
                      height: 32,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
