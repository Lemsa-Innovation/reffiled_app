import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:refilled_app/pages/add_address_page.dart';
import 'package:refilled_app/pages/add_card.dart';
import 'package:refilled_app/pages/address_list_page.dart';
import 'package:refilled_app/pages/cart_page.dart';
import 'package:refilled_app/pages/checkout_page.dart';
import 'package:refilled_app/pages/confirm_order_page.dart';
import 'package:refilled_app/pages/home_page.dart';
import 'package:refilled_app/pages/introduction_screen.dart';
import 'package:refilled_app/pages/invite_friends.dart';
import 'package:refilled_app/pages/live_tracking_page.dart';
import 'package:refilled_app/pages/login_page.dart';
import 'package:refilled_app/pages/my_orders.dart';
import 'package:refilled_app/pages/my_qr_code_page.dart';
import 'package:refilled_app/pages/order_detail.dart';
import 'package:refilled_app/pages/payment_methods.dart';
import 'package:refilled_app/pages/product_detail_page.dart';
import 'package:refilled_app/pages/profile.dart';
import 'package:refilled_app/pages/search_places.dart';
import 'package:refilled_app/pages/search_product_page.dart';
import 'package:refilled_app/pages/signup_page.dart';
import 'package:refilled_app/pages/track_order_page.dart';
import 'package:refilled_app/pages/verify_otp_page.dart';
import 'package:refilled_app/pages/wallet.dart';

import 'package:refilled_app/utils/stripe_constants.dart';
import 'pages/splash.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notification', //title
    description: 'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeConstants.STRIPE_PUBLISHABLE_KEY;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.Refilled';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    getPages: [
      GetPage(name: '/splash', page: () => Splash()),
      GetPage(
          name: '/introduction',
          page: () => const OnBoardingPage(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 500)),
      GetPage(
          name: '/login',
          page: () => const Login(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/signup',
          page: () => const SignUp(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/verify_otp',
          page: () => const VerifyOTP(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/home',
          page: () => const Home(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/cart',
          page: () => Cart(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/product_detail',
          page: () => ProductDetail(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/address_list',
          page: () => AddressList(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/add_address',
          page: () => AddAddress(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/search_place',
          page: () => const SearchPlaces(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/profile',
          page: () => const Profile(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/invite_friends',
          page: () => InviteFriends(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/add_card',
          page: () => const AddCard(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/payment_methods',
          page: () => PaymentMethods(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/wallet',
          page: () => Wallet(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/my_orders',
          page: () => const MyOrders(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/order_detail',
          page: () => const OrderDetail(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/checkout',
          page: () => const CheckoutPage(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/confirm_order',
          page: () => const ConfirmOrderPage(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/track_order',
          page: () => TrackOrderPage(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/live_tracking',
          page: () => LiveTrackingPage(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/search_product',
          page: () => SearchProduct(),
          transition: Transition.downToUp,
          transitionDuration: const Duration(milliseconds: 300)),
      GetPage(
          name: '/my_qr_code',
          page: () => const MyQRCodePage(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300))
    ],
    theme: ThemeData(primaryColor: const Color(0xFF29ABE2)),
    localizationsDelegates: const [
      CountryLocalizations.delegate,
      //GlobalMaterialLocalizations.delegate,
      // GlobalWidgetsLocalizations.delegate,
    ],
  ));
}
