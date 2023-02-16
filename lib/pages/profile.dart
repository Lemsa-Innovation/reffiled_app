import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/profile_controller.dart';
import 'package:refilled_app/utils/log.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _profileController = Get.put<ProfileController>(ProfileController());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _countryCode;

  void _getUserData() async {
    _nameController.text = _profileController.currentUser?.name ?? '';
    _emailController.text = _profileController.currentUser?.email ?? '';
    _phoneController.text = _profileController.currentUser?.mobile == "0"
        ? ""
        : _profileController.currentUser?.mobile ?? '';
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    Log.debug(_profileController.currentUser?.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: const Text('PROFILE',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xff061737),
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: Get.back,
          ),
          actions: <Widget>[
            TextButton(
                onPressed: onEditClick,
                child: const Text(
                  'Update',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF29ABE2),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ))
          ],
        ),
        body: Form(
          key: _formKey,
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _TitleWidget(title: 'Full Name'),
                  const SizedBox(height: 8),
                  _InputFormField(
                    controller: _nameController,
                    hintText: 'Full Name',
                    inputeType: TextInputType.name,
                    validator: (val) => val != null && val.length > 3
                        ? null
                        : 'The full name is to short',
                  ),
                  const SizedBox(height: 32),
                  const _TitleWidget(title: 'E-Mail'),
                  const SizedBox(height: 8),
                  if (_profileController.currentUser?.email?.isNotEmpty ??
                      false)
                    Text(_profileController.currentUser?.email ?? '',
                            style: _textStyle)
                        .paddingOnly(left: 5)
                  else
                    _InputFormField(
                        inputeType: TextInputType.emailAddress,
                        controller: _emailController,
                        hintText: 'example@example.com',
                        validator: (val) =>
                            val != null && (val.isEmail || val.isEmpty)
                                ? null
                                : 'Please check your E-mail'),
                  const SizedBox(height: 32),
                  const _TitleWidget(title: 'Phone Number'),
                  const SizedBox(height: 8),
                  (_profileController.currentUser?.mobile?.isPhoneNumber ??
                          false)
                      ? Text(_profileController.currentUser?.mobile ?? '',
                              style: _textStyle)
                          .paddingOnly(left: 5)
                      : Row(children: [
                          Container(
                            height: 62,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFEEEEEE)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: CountryCodePicker(
                              onInit: (value) => _countryCode = value?.dialCode,
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: _InputFormField(
                              controller: _phoneController,
                              hintText: 'Phone',
                              inputeType: TextInputType.phone,
                              validator: (val) => val != null &&
                                      val.isEmpty |
                                          (val.length > 5 &&
                                              _countryCode != null &&
                                              '$_countryCode$val'.isPhoneNumber)
                                  ? null
                                  : 'Please check your phone number',
                            ),
                          )
                        ]),
                ],
              ),
            ),
          ),
        ));
  }

  TextStyle get _textStyle => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );
  void onEditClick() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final currentUser = _profileController.currentUser;
      final toUpdate = <String, dynamic>{};
      if (_nameController.text != currentUser?.name) {
        toUpdate["name"] = _nameController.text;
      }
      if (_emailController.text.isNotEmpty &&
          currentUser?.email != _emailController.text) {
        toUpdate["email"] = _emailController.text;
      }
      if (_phoneController.text.isNotEmpty && _countryCode != null) {
        toUpdate['mobile'] = '$_countryCode${_phoneController.text}';
      }
      if (toUpdate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Already Updated!!'),
            duration: Duration(milliseconds: 1000)));
        return;
      }

      await _profileController.updateProfile(toUpdate);
    }
  }
}

class _InputFormField extends StatelessWidget {
  const _InputFormField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.validator,
      required this.inputeType})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType inputeType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputeType,
      controller: controller,
      cursorColor: Colors.grey,
      validator: validator,
      decoration: InputDecoration(
        border: border,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFFEEEEEE),
        ),
        disabledBorder: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFF111719),
      ),
    );
  }

  static InputBorder get border => const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Color(0xFFEEEEEE)));
}

class _TitleWidget extends StatelessWidget {
  final String title;
  const _TitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 14.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: Color(0xFF9796A1))),
    );
  }
}
