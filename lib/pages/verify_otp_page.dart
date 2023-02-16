// ignore_for_file: library_prefixes

import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:refilled_app/controllers/auth_controller.dart';

import '../services/notification_service.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  Timer? _timer;
  int start = 300;
  String _otp = '';
  var showProgress = false;
  var authController = Get.put(AuthController());
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 5;
  var showResendButton = false;

  Map data = {};
  String? phone;
  @override
  void initState() {
    startTimer();
    Timer(
      const Duration(seconds: 3),
      () {
        NotificationController().showNotification(
            Math.Random.secure().nextInt(500), 'Your otp Code', _otp,
            clearAll: true);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as Map;
    phone = data['phone'];
    _otp = data['otp'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(
            'VERIFY PHONE',
            style: TextStyle(
              color: Color(0xFF061737),
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            iconSize: 24,
          )),
      body: Center(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  start > 10
                      ? '0${start ~/ 60}:${NumberFormat("00").format(start % 60)}'
                      : '00:0$start',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 34.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Code is sent to $phone',
                  style: const TextStyle(
                      color: Color(0xB3000000),
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 32,
                ),
                OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.center,
                  fieldWidth: 60,
                  keyboardType: TextInputType.number,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  otpFieldStyle: OtpFieldStyle(
                      borderColor: const Color(0xFF239CCC),
                      focusBorderColor: const Color(0xFF239CCC),
                      enabledBorderColor: const Color(0xFFE8E6EA)),
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 15,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 34.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat'),
                  onChanged: (pin) {},
                  onCompleted: matchOtp,
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: showResendButton,
                  child: TextButton(
                      onPressed: () {
                        resendOtp();
                      },
                      child: const Text(
                        'Send again',
                        style: TextStyle(
                            color: Color(0xFF239CCC),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      )),
                )
              ],
            ),
            Center(
              child: Visibility(
                visible: showProgress,
                child: const SpinKitFadingCube(
                  color: Color(0xFF239CCC),
                  size: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void matchOtp(String pin) async {
    var verified = await authController.verifyOTP(
        phoneNumber: data['phone'], pin: int.parse(pin));
    if (verified) {
      NotificationController().clearAll();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      return;
    }
    Get.snackbar('Error', 'You entred wrong OTP');
  }

  void resendOtp() async {
    var result = await authController.sendOtp(data['phone']);
    if (result != null) {
      _otp = result;
      Timer(
        const Duration(seconds: 3),
        () {
          NotificationController().showNotification(
              Math.Random.secure().nextInt(500), 'Your otp Code', result);
        },
      );
      setState(() {
        showResendButton = false;
        startTimer();
      });
    }
  }

  void startTimer() {
    start = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          _timer?.cancel();
          showResendButton = true;
        });
      } else {
        if (mounted) {
          setState(() {
            start--;
          });
        }
      }
    });
  }
}
