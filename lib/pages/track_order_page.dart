// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refilled_app/controllers/track_order_controller.dart';

class TrackOrderPage extends StatelessWidget {
  TrackOrderPage({Key? key}) : super(key: key);

  final _trackOrderController = Get.put(TrackOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'TRACK ORDER',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Delivering To',
              style: TextStyle(
                color: Color(0xFF061737),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/img_map.png',
                      ),
                      Center(
                        child: Image.asset(
                          'assets/img_marker.png',
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          _trackOrderController.addressTag.value,
                          style: const TextStyle(
                              color: Color(0xFF061737),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 15.0),
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Obx(
                        () => Text(
                          _trackOrderController.shippingAddress.value,
                          style: const TextStyle(
                              color: Color(0xFF4E5A5F),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
              color: const Color(0x1AB5C9FF),
              //  padding: EdgeInsets.symmetric(ho),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/ic_check_round.png',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Obx(
                      () => Text(
                        _trackOrderController.orderStatusText.value,
                        style: const TextStyle(
                            color: Color(0xFF1D2E5B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'),
                      ),
                    )
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ic_status_order_preparing.png',
                  height: 30,
                ),
                Obx(
                  () => Expanded(
                    child: Container(
                      height: 4,
                      width: 16,
                      color: _trackOrderController.orderCurrentStatus.value ==
                                  'shipped' ||
                              _trackOrderController.orderCurrentStatus.value ==
                                  'arrived' ||
                              _trackOrderController.orderCurrentStatus.value ==
                                  'delivered'
                          ? const Color(0xFF29ABE2)
                          : const Color(0xFFE8E8E8),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/ic_status_order_packed.png',
                  height: 30,
                ),
                Obx(
                  () => Expanded(
                    child: Container(
                      height: 4,
                      width: 16,
                      color: _trackOrderController.orderCurrentStatus.value ==
                                  'arrived' ||
                              _trackOrderController.orderCurrentStatus.value ==
                                  'delivered'
                          ? const Color(0xFF29ABE2)
                          : const Color(0xFFE8E8E8),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/ic_status_order_on_the_way.png',
                  height: 30,
                ),
                Obx(
                  () => Expanded(
                    child: Container(
                      height: 4,
                      width: 16,
                      color: _trackOrderController.orderCurrentStatus.value ==
                              'delivered'
                          ? const Color(0xFF29ABE2)
                          : const Color(0xFFE8E8E8),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/ic_status_order_completed.png',
                  height: 30,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '', //Your food is being cooked
              style: TextStyle(
                  color: Color(0xFF1D2E5B),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 11),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(24)),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(16),
                child: Obx(
                  () => Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      GoogleMap(

                          //myLocationEnabled: true,
                          tiltGesturesEnabled: true,
                          //compassEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          gestureRecognizers: {}
                            ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer()))
                            ..add(Factory<ScaleGestureRecognizer>(
                                () => ScaleGestureRecognizer()))
                            ..add(Factory<TapGestureRecognizer>(
                                () => TapGestureRecognizer()))
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer())),
                          onTap: (LatLng position) {
                            if (_trackOrderController.orderStatus !=
                                'confirmed') {
                              Get.toNamed('/live_tracking', arguments: {
                                'order_id': _trackOrderController.currentOrderId
                              });
                            }
                          },
                          markers: _trackOrderController.markers.value,
                          polylines: _trackOrderController.polyLines.value,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _trackOrderController.originLatitude.value,
                                _trackOrderController.originLongitude.value,
                              ),
                              zoom: _trackOrderController.zoomLevel),
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) =>
                              _trackOrderController.onMapCreated(
                                  controller, true)),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFFF5D5D)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Arriving Within'.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xBFFFFFFF),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                fontSize: 9,
                              ),
                            ),
                            Obx(
                              () => Text(
                                '${_trackOrderController.deliveryTime.value.split(' ').first} min',
                                style: const TextStyle(
                                  color: Color(0xBFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
