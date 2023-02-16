import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/wallet_controller.dart';
import 'package:refilled_app/utils/global.dart';

class Wallet extends StatelessWidget {
  Wallet({Key? key}) : super(key: key);
  final _walletController = Get.put(WalletController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'WALLET',
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
        () => _walletController.showProgress.value
            ? const Center(
                child: SpinKitFadingCube(
                  color: Color(0xFF239CCC),
                  size: 50.0,
                ),
              )
            : RefreshIndicator(
          key: _refreshIndicatorKey,

          color: Colors.white,
          backgroundColor: Colors.blue,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return asynchronous code
            _walletController.getWallet();
          },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            'assets/wallet.png',
                            height: 176,
                            width: 176,
                          )),
                      Center(
                        child: Obx(
                          () => Text(
                            Global.formatPrice(
                                _walletController.walletAmount.value.toDouble()),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 49.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'montserrat'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Center(
                        child: Text(
                          'WALLET AMOUNT',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              color: Color(0xFF061737)),
                        ),
                      ),
                      const Divider(
                        height: 60,
                        color: Color(0x1A000000),
                      ),
                      Visibility(
                        visible:
                            _walletController.referrals.isNotEmpty ? true : false,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'REFERAL EARNED',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: Color(0xFF061737)),
                          ),
                        ),
                      ),
                      Obx(
                        () => _walletController.referrals.isEmpty
                            ? const SizedBox(
                                height: 300,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24),
                                    child: Text(
                                      'Start referring to earn points',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _walletController.referrals.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return referralEarnedCell(index);
                                }),
                      )
                    ],
                  ),
                ),
            ),
      ),
    );
  }

  Widget referralEarnedCell(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _walletController.referrals[index].description,
                      style: const TextStyle(
                          color: Color(0xFF061737),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      _walletController.formatDate(
                          _walletController.referrals[index].createdDtm),
                      style: const TextStyle(
                          color: Color(0xFF898989),
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
              Text(
                Global.formatPrice(_walletController.referrals[index].amount.toDouble()),
                style: const TextStyle(
                    color: Color(0xFF061737),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
