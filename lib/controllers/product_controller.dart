import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refilled_app/controllers/cart_controller.dart';
import 'package:refilled_app/controllers/home_controller.dart';
import 'package:refilled_app/data/model/product_category_res_model.dart';
import 'package:refilled_app/data/model/product_detail_res_model.dart';
import 'package:refilled_app/data/model/product_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final cartController = Get.put(CartController());
  final List<Category> categories = [];
  List<Product> products = [];
  final  allProducts = <Product>[].obs;
  var searchProducts = <Product>[].obs;
  String selectedCategory = "Popular Products";
  var showProgress = false.obs;
  ProductData? selectedProductData;
  int selectedProductId = 0;
  var mQuantity = 0.obs;
  var mItemPrice = 0.obs;
  var productImage = ''.obs;
  var productName = ''.obs;
  var productCategoryName = ''.obs;
  var productDescription = ''.obs;
  var productStoreName = ''.obs;
  var productStoreImage = ''.obs;
  var productStoreDesc = ''.obs;
  var productDiscount = 0.obs;
  final isWorking = false.obs;
  Future<List<Category>> fetchProductCategories(
      String token, LatLng? userLocation) async {
    isWorking(true);
    var result =
        await RemoteServices.fetchProductCategories(token, userLocation);
    isWorking(false);
    if (result != null) {
      if (result.success) {
        categories.clear();
        return result.data;
      } else {
        Get.snackbar("Error", result.message);
        return List.empty();
      }
    } else {
      return List.empty();
    }
  }

  Future<List<Product>> fetchPopularProduct(String token,
      {required LatLng? userLocation}) async {
    selectedCategory = "Popular Products";
    isWorking(true);
    var result = await RemoteServices.fetchPopularProducts(token,
        userLocation: userLocation);
    isWorking(false);
    if (result != null) {
      if (result.success) {
        products.clear();
        return result.data;
      } else {
        Get.snackbar("Error", result.message);
        return List.empty();
      }
    } else {
      return List.empty();
    }
  }

  Future<List<Product>> fetchProducts(String token, int categoryId,
      String categoryName, LatLng? userLocation) async {
    selectedCategory = categoryName;
    isWorking(true);
    var result = await RemoteServices.fetchProducts(token, categoryId,
        latitude: userLocation?.latitude, longitude: userLocation?.longitude);
    isWorking(false);
    if (result != null) {
      if (result.success) {
        products.clear();
        return result.data;
      } else {
        Get.snackbar("Error", result.message);
        return List.empty();
      }
    } else {
      return List.empty();
    }
  }


  Future<List<Product>> fetchAllProducts(String token, LatLng? userLocation) async {
    isWorking(true);
    var result = await RemoteServices.fetchAllProducts(token, latitude: userLocation?.latitude, longitude: userLocation?.longitude);
    isWorking(false);
    if (result != null) {
      if (result.success) {
        products.clear();
        selectedCategory = 'All Products';
        //products.addAll(result.data);
        return result.data;
      } else {
        Get.snackbar("Error", result.message);
        return List.empty();
      }
    } else {
      return List.empty();
    }
  }


  void searchProduct(String keyword, LatLng userLocation) async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token') ?? "";
    isWorking(true);
    var result = await RemoteServices.searchProducts(token, keyword,
        latitude: userLocation.latitude, longitude: userLocation.longitude);
    isWorking(false);
    if (result != null) {
      if (result.success) {
        searchProducts.clear();
        searchProducts.addAll(result.data);
      } else {
        Get.snackbar("Error", result.message);
        return searchProducts.addAll(List.empty());
      }
    } else {
      return searchProducts.addAll(List.empty());
    }
  }

  Future<void> fetchProductDetail(
      String token, int productId, LatLng? userPosition) async {
    isWorking(true);
    showProgress.value = true;
    var result =
        await RemoteServices.fetchProductDetail(token, productId, userPosition);
    isWorking(false);
    if (result == null) return;

    if (result.success) {
      selectedProductData = result.data;
      productImage.value = selectedProductData?.productImg ?? "";
      productName.value = selectedProductData?.name ?? '';
      productCategoryName.value = selectedProductData?.categoryName ?? '';
      productDescription.value = selectedProductData?.description ?? '';
      mItemPrice.value = selectedProductData?.price ?? 0;
      mQuantity.value = selectedProductData?.cartQuantity ?? 0;
      showProgress.value = false;
      productStoreImage.value = selectedProductData?.storeImage ?? '';
      productStoreName.value = selectedProductData?.storeName ?? 'Unknown';
      productStoreDesc.value = selectedProductData?.storeDesc ?? '';
      productDiscount.value = selectedProductData?.discount ?? 0;
      return;
    }
    Get.snackbar("Error", result.message);
  }

  Future<bool> addProductToCart() async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token');
    if (token == null || selectedProductData?.id == null) {
      return false;
    }

    showProgress.value = true;
    var result = await RemoteServices.addToCart(
        token, selectedProductData!.id, mQuantity.value);
    showProgress.value = false;

    if (result != null) {
      if (result.success) {
        Future.delayed(const Duration(seconds: 1), () {
          showProgress.value = false;
          cartController.getMyCart();
          //  mQuantity.value =  0;
          //  Get.offNamed('/cart',arguments: true);
        });
      } else {
        Get.snackbar("Error", result.message);
      }
    }

    return false;
  }

  void addToCartWithQuantity() {
    if (mQuantity.value == selectedProductData?.stock) {
      Get.snackbar("Limit exceeded",
          "We are not having enough items in the stock.Please proceed with the selected items");
    } else {
      mQuantity.value++;
      addProductToCart();
    }
  }

  void removeFromCartWithQuantity() {
    if (mQuantity.value > 0) {
      mQuantity.value--;
      addProductToCart();
    }
  }

  void onProductClick(int position) async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token');

    if (token == null) {
      return;
    }
    try {
      fetchProductDetail(token, products[position].id,
          Get.find<HomeController>().currentUserLocation.value);
    } catch (_) {}
  }

  void onSearchProductClick(int position) async {
    SharedPreferences pref = await _pref;
    var token = pref.getString('user_token');

    if (token == null) {
      return;
    }
    try {
      fetchProductDetail(token, searchProducts[position].id,
          Get.find<HomeController>().currentUserLocation.value);
    } catch (_) {}
  }

  getUserLocation() {}
}
