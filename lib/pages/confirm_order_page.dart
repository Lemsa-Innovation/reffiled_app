import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({Key? key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemSound.play(SystemSoundType.alert);
    return WillPopScope(
      onWillPop: () async {
        Get.offNamedUntil('home', (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            '',
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
              Get.offNamedUntil('home', (route) => false);
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                'assets/img_confirm_order.png',
                height: 150,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Your order has been successfully placed',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF061737),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat"),
              ),
              const SizedBox(
                height: 32,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Sit back and relax while we prepre your order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat"),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.offNamedUntil('home', (route) => false);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)))),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
                    child: const Center(
                      child: Text(
                        'Go back to home',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
