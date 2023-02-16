import 'package:get/get.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order {
  int orderId;

  int productId;
  String productName;
  int price;
  String productImg;
  String productDesc;
  int quantity;
  String deliveryTime;
  String orderStatus;

  Order(
      {required this.orderId,
      required this.productId,
      required this.productName,
      required this.price,
      required this.productImg,
      required this.productDesc,
      required this.quantity,
      required this.deliveryTime,
      required this.orderStatus});
}

class OrdersController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var showProgress = false.obs;

  var upcomingOrders = <Order>[].obs;
  var pastOrders = <Order>[].obs;

  @override
  void onInit() {
    getUpcomingOrders();
    getPastOrders();
    super.onInit();
  }

  void getUpcomingOrders() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';

    var result = await RemoteServices.getUpcomingOrders(token);

    if (result != null) {
      if (result.success) {
        var orders = result.data;
        upcomingOrders.clear();
        for (var order in orders) {
          for (var item in order.orderDetails) {
            upcomingOrders.add(Order(
                orderId: order.id,
                productId: item.productId,
                productName: item.productName,
                price: item.price,
                productImg: item.productImg,
                productDesc: item.productDesc,
                quantity: item.quantity,
                deliveryTime: order.deliveryTime,
                orderStatus: order.status));
          }
        }
      } else {
        upcomingOrders.addAll(List.empty());
      }
    }
  }

  void getPastOrders() async {
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';

    var result = await RemoteServices.getPastOrders(token);

    if (result != null) {
      if (result.success) {
        var orders = result.data;
        pastOrders.clear();
        for (var order in orders) {
          for (var item in order.orderDetails) {
            pastOrders.add(Order(
                orderId: order.id,
                productId: item.productId,
                productName: item.productName,
                price: item.price,
                productImg: item.productImg,
                productDesc: item.productDesc,
                quantity: item.quantity,
                deliveryTime: order.deliveryTime,
                orderStatus: order.status));
          }
        }
      } else {
        pastOrders.addAll(List.empty());
      }
    }
  }

  void cancelOrder(int position) async {
    SharedPreferences pref = await _pref;
    var token = pref.getString("user_token") ?? '';
    showProgress.value = true;
    var result = await RemoteServices.cancelOrder(
        token, upcomingOrders[position].orderId.toString());
    showProgress.value = false;

    if (result != null) {
      if (result.success) {
        try {
          getUpcomingOrders();
        } catch (_) {}
      } else {
        Get.snackbar("Error", result.message);
      }
    }
  }
}
