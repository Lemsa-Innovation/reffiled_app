import 'package:get/get.dart';
import 'package:refilled_app/data/model/sign_up_res_model.dart';
import 'package:refilled_app/data/model/update_profile_res_model.dart';
import 'package:refilled_app/services/remote_services.dart';

class ProfileController extends GetxController {
  final _currrentUser = Rx<SignUpResModel>(SignUpResModel());

  UserData? get currentUser => _currrentUser.value.userData;
  @override
  void onInit() {
    super.onInit();
    SignUpResModel.load().then((user) {
      if (user != null) {
        _currrentUser.value = user;
      }
    });
  }

  Future<void> saveUserData(ProfileData profile) async {
    _currrentUser(_currrentUser.value.copyWith(profile.toJson()));
    _currrentUser.value.save();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    var result = await RemoteServices.updateProfile(
        _currrentUser.value.token ?? '', data);

    if (result != null) {
      if (result.success) {
        Get.snackbar("Updated", result.message);
        await saveUserData(result.data);
      } else {
        Get.snackbar("Error", result.message);
      }
    }
  }
}
