import 'dart:developer';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQRCodePage extends StatefulWidget {
  const MyQRCodePage({Key? key}) : super(key: key);

  @override
  _MyQRCodePageState createState() => _MyQRCodePageState();
}

class _MyQRCodePageState extends State<MyQRCodePage> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String userName = '';
  String myQrCode = '';

  @override
  void initState() {
    super.initState();
    setupData();
  }

  void setupData() async {
    SharedPreferences pref = await _pref;
    var name = pref.getString('user_name') ?? '';
    var code = encryptValue(pref.getString('user_id') ?? 'qwertyufg');

    setState(() {
      userName = name;
      myQrCode = code;
    });
  }

  String encryptValue(String value) {
    final myKey = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    log("iv = $iv");
    final encrypter = encrypt.Encrypter(encrypt.AES(myKey));

    final encrypted = encrypter.encrypt(value, iv: iv);
    log("Encrypt = $encrypted");
    // log(encrypted.bytes);
    // print(encrypted.base16);
    // print(encrypted.base64);
    return encrypted.base64;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            gradient:
                LinearGradient(colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
        child: Stack(
          children: [
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        userName.toUpperCase(),
                        style: const TextStyle(
                            color: Color(0xFF111719),
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: QrImage(
                        data: myQrCode,
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
                        //  embeddedImage: AssetImage('assets/images/my_embedded_image.png'),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(80, 80),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text(
                'My QR Code'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
