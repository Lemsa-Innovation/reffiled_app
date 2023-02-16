import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:refilled_app/data/model/past_order_detail_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:refilled_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailController extends GetxController {
  var showProgress = false.obs;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var orderedProducts = <OrderedProduct>[].obs;
  String currentOrderId = '';
  var subTotal = ''.obs;
  var taxFee = ''.obs;
  var deliveryAmount = ''.obs;
  var deliveryTime = ''.obs;
  var totalAmount = ''.obs;
  var orderNumber = ''.obs;
  var paymentBy = ''.obs;
  var cardLast4 = ''.obs;
  var orderDate = ''.obs;
  var orderTime = ''.obs;
  var deliveryAddress = ''.obs;
  var orderStatus =''.obs;
  var promoAmount = ''.obs;
  String invoiceUrl = '';

  @override
  void onInit() {
    currentOrderId = Get.arguments['order_id'];
    getOrderDetail(currentOrderId);
    super.onInit();
  }

  void getOrderDetail(String orderId) async {
    showProgress.value = true;
    SharedPreferences pref = await _pref;
    String token = pref.getString('user_token') ?? '';
    var result = await RemoteServices.getPastOrderDetail(token, orderId);
    if (result != null) {
      if (result.success) {
        orderedProducts.addAll(result.data.orderDetails);
        var orderData = result.data;
        subTotal.value = Global.formatPriceDouble(orderData.subtotal.toDouble());
        taxFee.value = Global.formatPriceDouble(orderData.tax.toDouble());
        orderStatus.value = orderData.orderStatus;
        deliveryAmount.value =
            Global.formatPriceDouble(double.parse(orderData.deliveryAmount));
        deliveryTime.value = orderData.deliveryTime;
        totalAmount.value =
            Global.formatPriceDouble(double.parse(orderData.totalAmount));
        orderNumber.value = orderData.id.toString();
        paymentBy.value = orderData.paymentType;
        cardLast4.value = orderData.cardNumber;
        orderDate.value =
            DateFormat('MMM dd, yyyy').format(orderData.createdDtm);
        orderTime.value = DateFormat('hh:mm aa').format(orderData.createdDtm);

        var deliveryAddressBuffer = StringBuffer();

        if(orderData.address.aditionalAddress.isNotEmpty){
          deliveryAddressBuffer.write(orderData.address.aditionalAddress);
          deliveryAddressBuffer.write(", ");
        }

        if(orderData.address.address.isNotEmpty){
          deliveryAddressBuffer.write(orderData.address.address);
        }

        deliveryAddress.value = deliveryAddressBuffer.toString();
        invoiceUrl = orderData.invoice;
        promoAmount.value = Global.formatPriceDouble(double.parse(orderData.promoAmount));

      } else {
        Get.snackbar('Error', result.message);
      }
    }

    showProgress.value = false;
  }

  void viewInvoiceInBrowser()async{

    if(invoiceUrl.isNotEmpty){
      if(await canLaunch(invoiceUrl)){
        await launch(invoiceUrl);
      }else{
        Get.snackbar('Something went wrong', 'Enable to view invoice');
      }
    }

  }
}
