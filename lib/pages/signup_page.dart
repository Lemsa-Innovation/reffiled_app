import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/auth_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var authController = Get.put(AuthController());
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final referralController = TextEditingController();
  var isEmailAvailable = false;
  var isMobileExist = false;
  var showProgress = false;
  bool _isReferral = false;
  final _formKey = GlobalKey<FormState>();
  var _countryCode = '+1';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF001F5A),
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'CREATE ACCOUNT',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 16.0),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: const Color(0xFF001F5A),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Center(
                          child: Container(
                            height: 250,
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/img_splash.png',
                              width: 200,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 30,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border.fromBorderSide(BorderSide(
                                    width: 0.0, color: Colors.white)),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.black,
                          controller: nameController,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD9D9D9), width: 1.0)),
                              labelText: 'Full Name',
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                              contentPadding: const EdgeInsets.only(
                                  left: 24.0, right: 24.0)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter full name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        // const SizedBox(
                        //   height: 16.0,
                        // ),
                        // TextFormField(
                        //   keyboardType: TextInputType.emailAddress,
                        //   cursorColor: Colors.black,
                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                        //   controller: emailController,
                        //   style: const TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 16.0,
                        //       fontFamily: 'Montserrat',
                        //       fontWeight: FontWeight.w700),
                        //   decoration: InputDecoration(
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(16.0),
                        //           borderSide: const BorderSide(
                        //             color: Colors.grey,
                        //           )),
                        //       focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(16),
                        //           borderSide: const BorderSide(
                        //               color: Color(0xFFD9D9D9), width: 1.0)),
                        //       labelText: 'Email',
                        //       labelStyle: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 14.0,
                        //           fontFamily: 'Montserrat',
                        //           fontWeight: FontWeight.w400),
                        //       contentPadding: const EdgeInsets.only(
                        //           left: 24.0, right: 24.0)),
                        //   onChanged: (val) => isEmailAvailable = true,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return null;
                        //     }
                        //     if (!EmailValidator.validate(value)) {
                        //       return 'Email address is not valid';
                        //     }
                        //     if (!isEmailAvailable) {
                        //       return 'This email is already taken.';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        const SizedBox(
                          height: 16.0,
                        ),
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
                                onChanged: (value) {
                                  if (value.dialCode != null) {
                                    _countryCode = value.dialCode!;
                                  }
                                },
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
                                        borderRadius: BorderRadius.circular(16),
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
                                onChanged: (val) => isMobileExist = false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 5) {
                                    return 'Please enter phone number';
                                  }
                                  if (isMobileExist) {
                                    return 'Phone Already exist';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 0.0,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Checkbox(
                                  activeColor: const Color(0xFF29ABE2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  value: _isReferral,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isReferral = value ?? false;
                                    });
                                  }),
                              const Text(
                                'Having referral code?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Visibility(
                          visible: _isReferral,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            controller: referralController,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD9D9D9), width: 1.0)),
                                labelText: 'Referral Code',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                                contentPadding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0)),
                            validator: (value) {
                              if (value!.isEmpty && _isReferral) {
                                return 'Please enter referral Code';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF0EE2F5),
                                Color(0xFF29ABE2)
                              ])),
                          child: ElevatedButton(
                            onPressed: () {
                              validateData();
                            },
                            child: const Text(
                              'Sign Up',
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
                        const SizedBox(height: 16.0),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.offAllNamed('/login');
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Color(0xFF239CCC)),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24)
                ],
              ),
            ),
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
    );
  }

  void validateData() async {
    FocusScope.of(context).requestFocus(FocusNode());
  //  if (_formKey.currentState!.validate()) {
      var name = nameController.text.toString().trim();
     // var email = emailController.text.toString().trim();
      var phone = _countryCode + phoneController.text.toString().trim();
      var referralCode =
          _isReferral ? referralController.text.toString().trim() : '0';
    log('name = $name\nphone=$phone\nreferralCode = $referralCode');

    signUpUser(name, phone, referralCode);
   // }
  }

  @Deprecated('not need for now')
  void sendSignupOtp(
      String name, String email, String phone, String referralCode) async {
    setState(() {
      showProgress = true;
    });
    var otp = await authController.sendOtp(phone);
    log('OTP = $otp');
    setState(() {
      showProgress = false;
    });
    if (otp != null) {
      Navigator.pushNamed(context, '/verify_otp', arguments: {
        'isFromSignup': true,
        'otp': otp,
        'name': name,
        'email': email,
        'phone': phone,
        'referral_code': referralCode,
      });
    }
  }

  void signUpUser(
      String name, String phone, String referralCode) async {
    setState(() {
      showProgress = true;
    });
    var otp = await authController.signupUser(name, phone, referralCode);
    log("otp:::: $otp");
    if (otp != null) {
      Navigator.pushNamed(context, '/verify_otp', arguments: {
        'isFromSignup': true,
        'otp': otp.toString(),
        'name': name,
        //'email': email,
        'phone': phone,
        'referral_code': referralCode,
      });
    }

    setState(() {
      showProgress = false;
    });
  }
}
