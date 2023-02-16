import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:refilled_app/controllers/referral_controller.dart';

class InviteFriends extends StatelessWidget {
  InviteFriends({Key? key}) : super(key: key);

  final _referralController = Get.put(ReferralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'INVITE FRIENDS',
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(
        () => _referralController.showProgress.value
            ? const Center(
                child: SpinKitFadingCube(
                  color: Color(0xFF239CCC),
                  size: 50.0,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Image.asset('assets/refer.png'),
                        width: 257,
                        height: 172,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                        child: const Center(
                          child: Text(
                            'Refer A Friend',
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                color: Color(0xFF061737)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          children: [

                            //     sender, recipient, deliver are false :   Invite Your Friend

                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isFalse)
                              const Text(
                                'Invite your friend',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),

                            //     only delivery is true : Invite friend and you get both free delivery

                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isTrue)


                              const Text(
                              'Invite your friend and you both can get Free delivery',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4E5A5F)),
                            ),


//    only sender is true : Invite friend and you get bonus (current case : 10$ )
                          if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isFalse)
                            const Text(
                              'Invite your friend and you get',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4E5A5F)),
                            ),
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isFalse)
                              Text(
                              ' \$${_referralController.refPrice.value} ',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4E5B6F)),
                            ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isTrue)
                              const Text(
                                'Invite your friend and you get',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isTrue)
                              Text(
                                ' \$${_referralController.refPrice.value} ',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5B6F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isTrue)

                            const Text(
                              'and',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4E5A5F)),
                            ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isTrue)
                              const Text(
                              ' both ',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4E5A5F)),
                            ),
//0xFF29ABE2
                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isFalse && _referralController.deliveryBonus.isTrue)
                            const Text(
                              'get free delivery',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF4E5A5F)),
                            ),

    ///    only recipient is true : Invite friend and he gets bonus (current case : 10$ )  - if delivery = true : and both get free delivery  \
                            ///
                            ///

                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isFalse)
                              const Text(
                                'Invite your friend and he get',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),
                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isFalse)
                              Text(
                                ' \$${_referralController.refPrice.value} ',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5B6F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                'Invite your friend and he get',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              Text(
                                ' \$${_referralController.refPrice.value} ',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5B6F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)

                              const Text(
                                'and',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                ' both ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),
//0xFF29ABE2
                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isFalse && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                'get free delivery',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


//
                          //
                            //
                            //
//     sender, recipient are true : invite friend and you get both bonus  - if delivery = true : and both get free delivery

                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isFalse)
                              const Text(
                                'Invite your friend and you',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),

                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isFalse)
                              const Text(
                                ' both ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isFalse)
                              const Text(
                                'get',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isFalse)
                              Text(
                                ' \$${_referralController.refPrice.value} ',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5B6F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                'Invite your friend and you',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                ' both ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                'get',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              Text(
                                ' \$${_referralController.refPrice.value} ',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5B6F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)

                              const Text(
                                'and',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),

                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                ' both ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),
//0xFF29ABE2
                            //    only sender is true : Invite friend and you get bonus (current case : 10$ ) - if delivery = true : and both get free delivery
                            if(_referralController.senderBonus.isTrue && _referralController.recipientBonus.isTrue && _referralController.deliveryBonus.isTrue)
                              const Text(
                                'get free delivery',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF4E5A5F)),
                              ),


                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                    child: const Text(
                      'Your Referral code',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: Color(0xFFA3A3A4)),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EE2F5).withAlpha(30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Center(
                      child: Text(
                        _referralController.referralCode.value,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Color(0xFF29ABE2)),
                      ),
                    ),
                  ),
                  /* Container(
                    margin: EdgeInsets.fromLTRB(24, 32, 24, 0),
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                            colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
                    child: Center(
                      child: TextButton.icon(
                        label: const Text(
                          'COPY LINK',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins'),
                        ),
                        onPressed: () {
                          _referralController.codeToClipBoard();
                        },
                        icon: const Icon(
                          Icons.copy_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/
                  InkWell(
                    onTap: () async {
                      await _referralController.shareReferralCode();
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                              colors: [Color(0xFF0EE2F5), Color(0xFF29ABE2)])),
                      child: const Center(
                        child: Text(
                          'Share',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: MaterialButton(
                        onPressed: () => {},
                        child: const Text(
                          '',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: Color(0xFF29ABE2)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //
      // ),
    );
  }
}
