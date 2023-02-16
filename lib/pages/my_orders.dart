import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refilled_app/controllers/orders_controller.dart';
import 'package:refilled_app/pages/past_orders.dart';
import 'package:refilled_app/pages/upcoming_orders.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
    Get.put(OrdersController());
  }

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: _selectedTab);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'MY ORDERS',
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
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: const Border.fromBorderSide(
                    BorderSide(color: Color(0xFFF2EAEA), width: 1.0))),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedTab = 0;
                          _pageController.animateToPage(_selectedTab,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)))),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                              colors: _selectedTab == 0
                                  ? [
                                      const Color(0xFF0EE2F5),
                                      const Color(0xFF29ABE2)
                                    ]
                                  : [Colors.white, Colors.white]),
                        ),
                        child: Center(
                          child: Text(
                            'Upcoming',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: _selectedTab == 0
                                    ? Colors.white
                                    : const Color(0xFF29ABE2)),
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedTab = 1;
                          _pageController.animateToPage(_selectedTab,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)))),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                              colors: _selectedTab == 1
                                  ? [
                                      const Color(0xFF0EE2F5),
                                      const Color(0xFF29ABE2)
                                    ]
                                  : [Colors.white, Colors.white]),
                        ),
                        child: Center(
                          child: Text(
                            'Past',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: _selectedTab == 1
                                    ? Colors.white
                                    : const Color(0xFF29ABE2)),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: PageView(
              pageSnapping: true,
              onPageChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              children: [UpcomingOrders(), PastOrders()],
            ),
          )
        ],
      ),
    );
  }
}
