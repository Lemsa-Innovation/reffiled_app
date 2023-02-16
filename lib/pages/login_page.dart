import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:refilled_app/controllers/auth_controller.dart';
import 'package:refilled_app/utils/log.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String _countryCode = "+1";
  bool isShowProgress = false;
  bool isPhoneRegistered = false;
  GoogleSignInAccount? userGoogleAccount;
  final _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // _googleSignIn.signOut();
    // FacebookAuth.instance.logOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF001F5A),
        body: SafeArea(
            child: Stack(children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: isKeyboard ? 0 : 4,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset('assets/img_splash.png',
                                width: 200)))),
                Expanded(
                  flex: 6,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0))),
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 0.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0)),
                                child: CountryCodePicker(
                                  onChanged: (value) =>
                                      {_countryCode = value.dialCode!},
                                  initialSelection: 'US',
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  flagDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  maxLength: 15,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Colors.black,
                                  controller: phoneController,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFD9D9D9),
                                              width: 1.0)),
                                      labelText: 'Phone',
                                      labelStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                      contentPadding: const EdgeInsets.only(
                                          left: 24.0, right: 24.0)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF0EE2F5),
                                  Color(0xFF29ABE2)
                                ])),
                            child: ElevatedButton(
                              onPressed: () {
                                sendOtp();
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  onSurface: Colors.transparent,
                                  shadowColor: Colors.transparent),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Expanded(
                                  child: Divider(
                                color: Color(0xFFD9D9D9),
                                height: 50,
                                indent: 16.0,
                                endIndent: 16.0,
                              )),
                              Text('or'),
                              Expanded(
                                  child: Divider(
                                height: 50,
                                color: Color(0xFFD9D9D9),
                                indent: 16.0,
                                endIndent: 16.0,
                              ))
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Container(
                                //   height: 50.0,
                                //   width: 50.0,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(16),
                                //       border: const Border.fromBorderSide(
                                //           BorderSide(
                                //               color: Color(0xFFD9D9D9),
                                //               width: 1.0))),
                                //   child: IconButton(
                                //     onPressed: () {
                                //       loginWithFacebook();
                                //     },
                                //     icon: Image.asset(
                                //       'assets/ic_facebook.png',
                                //     ),
                                //     iconSize: 24.0,
                                //   ),
                                //   padding: const EdgeInsets.all(4.0),
                                // ),
                                // const SizedBox(
                                //   width: 16.0,
                                // ),
                                // Container(
                                //   height: 50.0,
                                //   width: 50.0,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(16),
                                //       border: const Border.fromBorderSide(
                                //           BorderSide(
                                //         width: 1.0,
                                //         color: Color(0xFFD9D9D9),
                                //       ))),
                                //   child: IconButton(
                                //     onPressed: () {
                                //       loginWithGoogle();
                                //     },
                                //     icon: Image.asset(
                                //       'assets/ic_google.png',
                                //       color: const Color(0xFFE94040),
                                //     ),
                                //     iconSize: 16.0,
                                //   ),
                                //   padding: const EdgeInsets.all(4.0),
                                // )
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Get.toNamed('/signup');
                                    },
                                    child: const Text(
                                      'SIGN UP',
                                      style:
                                          TextStyle(color: Color(0xFF239CCC)),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
              child: Visibility(
                  visible: isShowProgress,
                  child: const SpinKitFadingCube(
                      color: Color(0xFF239CCC), size: 50.0)))
        ])));
  }

  void sendOtp() async {
    var phone = _countryCode + phoneController.text.toString();
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isShowProgress = true;
      });

      var result = await authController.loginUser(phone);
      setState(() {
        isShowProgress = false;
      });
      if (result?.otp != null) {
        Navigator.pushNamed(context, '/verify_otp', arguments: {
          'isFromSignup': false,
          'otp': result!.otp.toString(),
          'phone': phone
        });
        return;
      }
      Fluttertoast.showToast(msg: 'User not register');
    }
  }

  void loginWithGoogle() async {
    _googleSignIn
        .signIn()
        .then((value) => socialLoginWithGoogle(value))
        .catchError((e) {
      Log.error('GOOGLE_LOGIN_EXCEPTION = $e');
      Fluttertoast.showToast(msg: 'Error!!');
    });
  }

  socialLoginWithGoogle(GoogleSignInAccount? value) async {
    if (value != null) {
      var result = await authController.socialSignIn(
          name: value.displayName ?? '',
          email: value.email,
          socialId: value.id,
          loginBy: 'Google');

      if (result != null) {
        if (result.success) {
          authController.setUserData(result);
        } else {
          Get.snackbar('Error', result.message);
        }
      }
    }
  }

  void loginWithFacebook() async {
    var result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);

    if (result.status == LoginStatus.success) {
      var userData = await FacebookAuth.instance.getUserData();
      await authController.socialSignIn(
          name: userData['name'],
          email: userData['email'],
          socialId: userData['id'],
          loginBy: 'Facebook');
    }
  }
}
