import 'package:flutter/material.dart';

import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/payment_method_controller.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _paymentMethodController = Get.put(PaymentMethodController());

  OutlineInputBorder? border;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'ADD CARD',
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
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CreditCardForm(
                    formKey: _formKey,
                    obscureCvv: true,
                    obscureNumber: false,
                    cardNumber: _paymentMethodController.cardNumber,
                    cvvCode: _paymentMethodController.cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: _paymentMethodController.cardHolderName,
                    expiryDate: _paymentMethodController.expiryDate,
                    themeColor: Colors.grey,
                    cursorColor: Colors.grey,
                    textColor: const Color(0xFF061737),
                    cardHolderDecoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      focusedBorder: border,
                      enabledBorder: border,
                      errorBorder: border,
                      focusedErrorBorder: border,
                      labelText: 'Name on card',
                    ),
                    cardNumberDecoration: InputDecoration(
                        labelText: 'Card number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(
                          color: Color(0xFFD9D9D9),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFFD9D9D9),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        focusedBorder: border,
                        enabledBorder: border,
                        focusedErrorBorder: border,
                        errorBorder: border),
                    expiryDateDecoration: InputDecoration(
                        labelText: 'Expiry',
                        hintText: 'XX/XX',
                        hintStyle: const TextStyle(
                          color: Color(0xFFD9D9D9),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFFD9D9D9),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        focusedBorder: border,
                        focusedErrorBorder: border,
                        enabledBorder: border,
                        errorBorder: border),
                    cvvCodeDecoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      focusedBorder: border,
                      enabledBorder: border,
                      errorBorder: border,
                      focusedErrorBorder: border,
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    onCreditCardModelChange:
                        _paymentMethodController.onCreditCardModelChanged,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 24, right: 24),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            _paymentMethodController.addNewCard();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            primary: const Color(0xFF239CCC),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29.0))),
                        child: Container(
                          height: 58,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF0EE2F5),
                                Color(0xFF29ABE2)
                              ])),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 60),
                          child: const Center(
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: _paymentMethodController.showProgress.value,
              child: const Center(
                  child: SpinKitFadingCube(
                color: Color(0xFF239CCC),
                size: 50.0,
              )),
            ),
          )
        ],
      ),

      // bottomNavigationBar: BottomAppBar(
      //
      // ),
    );
  }

/* Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            SizedBox(height: 40,),

            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusColor: Colors.grey,
                hintText: 'Name on card',
                hintStyle: TextStyle(
                  color: Color(0x99000000),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                //labelText: 'Jon Snow',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFD9D9D9))),
              ),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111719),
              ),
            ),

            SizedBox(height: 16.0,),

            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusColor: Colors.grey,
                hintText: 'Card Number',
                hintStyle: TextStyle(
                  color: Color(0x99000000),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                //labelText: 'Jon Snow',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                ),
              ),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111719),
              ),
            ),

            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusColor: Colors.grey,
                        hintText: 'Expiry',
                        hintStyle: TextStyle(
                          color: Color(0x99000000),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        //labelText: 'Jon Snow',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusColor: Colors.grey,
                        hintText: 'Expiry',
                        hintStyle: TextStyle(
                          color: Color(0x99000000),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        //labelText: 'Jon Snow',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 24, right: 24),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      primary: Color(0xFF239CCC),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29.0))),
                  child: Container(
                    height: 58,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(29),
                        gradient: LinearGradient(
                            colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                    child: Center(
                      child: Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),*/

}
