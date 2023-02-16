import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
        bodyAlignment: Alignment.topCenter,
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero);

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
            child: Container(
                margin: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                child: TextButton(
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                  child: const Visibility(
                    visible: false,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: Color(0xFF239CCC),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ))),
      ),
      globalFooter: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: null,
                  borderRadius: BorderRadius.circular(50.0),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)]),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      fixedSize: const Size(double.infinity, 50.0),
                      shape: const RoundedRectangleBorder(
                          //  borderRadius: BorderRadius.circular(50.0)
                          )),
                ),
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: false,
                child: TextButton(
                  child: const Text('login',
                      style: TextStyle(
                          color: Color(0xFF239CCC),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () => Get.offNamed('/login'),
                ),
              ),
            ],
          ),
        ),
      ),
      pages: [
        PageViewModel(
            titleWidget: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
              child: Column(
                children: [
                  const Text(
                    "Order from your favourite stores or vendors",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      color: Color(0xFF1C1C1C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Image.asset(
                    'assets/intro_1.png',
                    width: 300.0,
                  ),
                ],
              ),
            ),
            // title: "Title 1",
            body: '',
            image: null,
            decoration: pageDecoration),
        PageViewModel(
            titleWidget: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
              child: Column(
                children: [
                  const Text(
                    "Choose from a wide range of  delicious meals",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      color: Color(0xFF1C1C1C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Image.asset(
                    'assets/intro_2.png',
                    width: 300.0,
                  ),
                ],
              ),
            ),
            // title: "Title 1",
            body: '',
            image: null,
            decoration: pageDecoration),
        PageViewModel(
            titleWidget: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
              child: Column(
                children: [
                  const Text(
                    "Enjoy instant delivery and payment",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      color: Color(0xFF1C1C1C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Image.asset(
                    'assets/intro_3.png',
                    width: 300.0,
                  ),
                ],
              ),
            ),
            // title: "Title 1",
            body: '',
            image: null,
            decoration: pageDecoration),
      ],
      showSkipButton: false,
      nextFlex: 0,
      showNextButton: false,
      showDoneButton: false,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16.0),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeColor: Color(0xFF239CCC),
          activeSize: Size(10.0, 10.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      dotsContainerDecorator: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)))),
    );
  }
}
