import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refilled_app/controllers/live_tracking_controller.dart';
import 'package:refilled_app/utils/global.dart';

class LiveTrackingPage extends StatelessWidget {
  LiveTrackingPage({Key? key}) : super(key: key);
  final _liveTrackOrderController = Get.put(LiveTrackingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(

                //myLocationEnabled: true,
                tiltGesturesEnabled: true,
                //compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer()))
                  ..add(Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
                markers: _liveTrackOrderController.markers,
                polylines: _liveTrackOrderController.polyLines,
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _liveTrackOrderController.originLatitude.value,
                      _liveTrackOrderController.originLongitude.value,
                    ),
                    zoom: _liveTrackOrderController.zoomLevel),
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) =>
                    _liveTrackOrderController.onMapCreated(controller, false)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: Text(
                          'Delivery Address',
                          style: TextStyle(
                              color: Color(0xFF9F9F9F),
                              fontSize: 10,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/ic_gps.png',
                            height: 24,
                            color: const Color(0xFF29ABE2),
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Expanded(
                              child: Text(
                                _liveTrackOrderController.shippingAddress.value,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Color(0xFF4E5A5F),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Montserrat",
                                    fontSize: 14.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: Text(
                          'Delivery Time',
                          style: TextStyle(
                              color: Color(0xFF9F9F9F),
                              fontSize: 10,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/ic_time.png',
                            height: 24,
                            color: const Color(0xFF29ABE2),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Obx(
                            () => Text(
                              '${_liveTrackOrderController.deliveryTime.value.split(' ').first} min',
                              style: const TextStyle(
                                  color: Color(0xFF4E5A5F),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Montserrat",
                                  fontSize: 14.0),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Obx(
                              () => Image.network(
                                Global.getImageUrl(_liveTrackOrderController
                                    .driverImage.value),
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Driver',
                                  style: TextStyle(
                                      color: Color(0xFF9F9F9F),
                                      fontSize: 10,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400),
                                ),
                                Obx(
                                  () => Text(
                                    _liveTrackOrderController.driverName.value,
                                    style: const TextStyle(
                                        color: Color(0xFF4E5A5F),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Montserrat",
                                        fontSize: 14.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: const Color(0xFF29ABE2),
                              child: IconButton(
                                onPressed: () {
                                  _liveTrackOrderController.callDriver();
                                },
                                icon: Image.asset(
                                  'assets/ic_call.png',
                                  height: 24,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                "TRACK ORDER",
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                iconSize: 24.0,
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
