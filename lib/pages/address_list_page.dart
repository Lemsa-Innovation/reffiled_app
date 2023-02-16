import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/address_controller.dart';

class AddressList extends StatelessWidget {
  AddressList({Key? key}) : super(key: key);

  final _addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    if (Get.arguments != null) {
      _addressController.isPickingAddress = Get.arguments['is_picking_address'];
    }
    return Scaffold(
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
            "ADDRESS",
            style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                color: Color(0xFF061737)),
          ),
        ),
        body: Obx(() => _addressController.showProgress.value
            ? const Center(
                child: SpinKitFadingCube(
                color: Color(0xFF239CCC),
                size: 50.0,
              ))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _addressController.addresses.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () =>
                                  _addressController.pickAddress(index),
                              child: addressCell(index));
                        }),
                    const SizedBox(
                      height: 32.0,
                    ),
                    TextButton.icon(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 32)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: const BorderSide(
                                        color: Color(0xFF29ABE2),
                                        width: 1.0)))),
                        onPressed: () async {
                          _addressController.initCurrentPosition();
                          Get.toNamed('/add_address');
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFF29ABE2),
                        ),
                        label: const Text(
                          'Add Address',
                          style: TextStyle(
                              color: Color(0xFF29ABE2),
                              fontFamily: 'Montserrat',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
              )));
  }

  Widget addressCell(index) {
    return Slidable(
      controller: _addressController.slidableController,
      direction: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _addressController.addresses[index].addressTag,
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      color: Color(0xFF061737)),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Text(
                    _addressController.getUserAddress(index),
                    style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "DMSans",
                        color: Color(0xFF898989)),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Divider(
                  height: 8.0,
                )
              ],
            ),
            const Image(
                image: AssetImage('assets/ic_double_arrow.png'), height: 12)
          ],
        ),
      ),
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        Container(
          height: double.infinity,
          color: const Color(0x261C56EC),
          child: TextButton(
              onPressed: () {
                _addressController.editAddress(index);
                _addressController.slidableController.activeState?.close();
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                    color: Color(0xFF061737),
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0),
              )),
        ),
        Container(
          height: double.infinity,
          color: const Color(0xFFD14444),
          child: TextButton(
              onPressed: () {
                _addressController.clickedIndex = index;
                _addressController.slidableController.activeState?.close();
                showAlert(index);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0),
              )),
        )
      ],
    );
  }

  void showAlert(index) {
    Get.defaultDialog(
        radius: 8,
        contentPadding: const EdgeInsets.all(8),
        barrierDismissible: false,
        title: "Alert",
        titleStyle: const TextStyle(
            color: Color(0xFF061737),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 16),
        middleText:
            "Are you sure you want to delete this address permanently from your address list? ",
        middleTextStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
            fontSize: 14),
        cancel: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF29ABE2), width: 1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                )),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Text("cancel",
                  style: TextStyle(
                      color: Color(0xFF29ABE2),
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
            )),
        confirm: ElevatedButton(
            onPressed: () {
              Get.back();
              _addressController.deleteAddress(index);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD14444)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                "Delete",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )));
  }
}
