import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refilled_app/controllers/address_controller.dart';

class AddAddress extends StatelessWidget {
  AddAddress({Key? key}) : super(key: key);
  final _addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    if (Get.arguments != null) {
      _addressController.isPickingAddress = Get.arguments['is_picking_address'];
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          iconSize: 24.0,
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF061737),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "ADD ADDRESS",
          style: TextStyle(
              fontSize: 16.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              color: Color(0xFF061737)),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      Obx(() => GoogleMap(
                          //myLocationEnabled: true,
                          tiltGesturesEnabled: true,
                          //compassEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          mapToolbarEnabled: false,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>{}
                                ..add(Factory<PanGestureRecognizer>(
                                    () => PanGestureRecognizer()))
                                ..add(Factory<ScaleGestureRecognizer>(
                                    () => ScaleGestureRecognizer()))
                                ..add(Factory<TapGestureRecognizer>(
                                    () => TapGestureRecognizer()))
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer())),
                          initialCameraPosition: CameraPosition(
                            target: _addressController.currentPosition.value,
                            zoom: 12.4746,
                          ),
                          mapType: MapType.normal,
                          markers: _addressController.markers,
                          onMapCreated: _addressController.onMapCreated)),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 20,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*   SizedBox(
                        height: 24.0,
                      ),
                    const Text(
                        'Add address',
                        style: TextStyle(
                            color: Color(0xFF061737),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat"),
                      ),*/
                      /* SizedBox(
                        height: 16,
                      ),
                      Stack(
                        children: [
                          TextButton(
                              onPressed: () {
                                _addressController.searchAddress();
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 40),
                                width: double.maxFinite,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Color(0x59677CBF), width: 1.0))),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Search address",
                                    style: TextStyle(
                                        color: Color(0x59677C80),
                                        fontSize: 14.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )),
                          Positioned.fill(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Image.asset(
                                      'assets/ic_search.png',
                                      width: 22,
                                    ),
                                  ))),
                          Positioned.fill(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child:
                                  ))
                        ],
                      ),
                     ,*/

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Current Location',
                              style: TextStyle(
                                  color: Color(0xFF1D2E5B),
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              _addressController.getCurrentLocation();
                            },
                            icon: Image.asset(
                              'assets/ic_gps.png',
                              width: 20,
                            ),
                            label: const Text(''),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/ic_location_check.png',
                            width: 14,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Obx(
                            () => Expanded(
                              child: Text(
                                _addressController.addressName.value,
                                style: const TextStyle(
                                    color: Color(0xFF1D2E5B),
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Obx(
                              () => Text(
                                _addressController.address.value,
                                style: const TextStyle(
                                    color: Color(0x59677CBF),
                                    fontSize: 11.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              onPressed: () {
                                _addressController.searchAddress();
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 1.0, color: Color(0xFF29ABE2)),
                              ),
                              child: const Text(
                                "Change",
                                style: TextStyle(
                                    color: Color(0xFF29ABE2),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    fontFamily: "Montserrat"),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 16.0,
                        color: Color(0x59677CBF),
                        thickness: 1,
                      ),
                      TextField(
                        controller:
                            _addressController.additionalAddressController,
                        cursorColor: const Color(0x59677CBF),
                        decoration: const InputDecoration(
                            hintText: "Apt / Suite / Unit",
                            hintStyle: TextStyle(
                                color: Color(0x59677CBF),
                                fontFamily: "Montserrat",
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0x59677CBF), width: 1)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0x59677CBF), width: 1))),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        controller: _addressController.addressTagController,
                        cursorColor: const Color(0x59677CBF),
                        decoration: const InputDecoration(
                            hintText: "Nickname",
                            hintStyle: TextStyle(
                                color: Color(0x59677CBF),
                                fontFamily: "Raleway",
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0x59677CBF), width: 1)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0x59677CBF), width: 1))),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_addressController.isEditAddress) {
                              _addressController.validateAndUpdateAddress();
                            } else {
                              _addressController.validateAndAddAddress();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 70),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF0EE2F5),
                                  Color(0xFF29ABE2)
                                ])),
                            child: Text(
                              _addressController.isEditAddress
                                  ? "Update Address"
                                  : "Add Address",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _addressController.showProgress.value ? true : false,
            child: const Center(
              child: SpinKitFadingCube(
                color: Color(0xFF239CCC),
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
