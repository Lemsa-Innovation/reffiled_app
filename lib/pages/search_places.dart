import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class SearchPlaces extends StatefulWidget {
  const SearchPlaces({Key? key}) : super(key: key);

  @override
  _SearchPlacesState createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions = [];

  void _autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void _getPlaceDetail(String placeId) async {
    var detailResponse = await googlePlace.details.get(placeId);
    log("Place_detail_res = ${detailResponse?.result?.name}");
    log("Place_detail_res = ${detailResponse?.result?.formattedAddress}");

    log("Location =  ${detailResponse?.result?.geometry?.location?.lat}");
    log("Location =  ${detailResponse?.result?.geometry?.location?.lng}");
    Get.back(result: {
      'lat': detailResponse?.result?.geometry?.location?.lat,
      'lng': detailResponse?.result?.geometry?.location?.lng
    });
  }

  @override
  void initState() {
    String apiKey = 'AIzaSyAaVnz03Xmd1cZGKPcVcKFHg0rAX4o_BAs';
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24.0,
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF061737),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "SEARCH ADDRESS",
          style: TextStyle(
              fontSize: 16.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              color: Color(0xFF061737)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TextField(
                cursorColor: const Color(0x59677C80),
                style: const TextStyle(
                    color: Color(0xFF061737),
                    fontSize: 14.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 16.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0x59677C80)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0x59677C80)),
                  ),
                  hintText: "Search",
                  hintStyle: const TextStyle(
                      color: Color(0x59677C80),
                      fontSize: 14.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _autoCompleteSearch(value);
                  } else {
                    if (predictions.isNotEmpty && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: predictions.length,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return placeCell(index);
                })
          ],
        ),
      ),
    );
  }

  Widget placeCell(index) {
    return ListTile(
      onTap: () {
        _getPlaceDetail(predictions[index].placeId ?? "");
      },
      leading: const Icon(
        Icons.location_on,
      ),
      title: Text(
        predictions[index].structuredFormatting?.mainText ?? "Unnamed location",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        predictions[index].description ?? "Unnamed location",
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          fontSize: 14,
        ),
      ),
    );
  }
}
