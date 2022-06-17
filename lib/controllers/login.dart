import 'package:ep_fm_dumping/controllers/utils/user_credential.dart';
import 'package:ep_fm_dumping/utils/xanx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final isPasswordObscure = true.obs;

  final tecUsername = TextEditingController();
  final tecPassword = TextEditingController();

  @override
  void onClose() {
    tecUsername.dispose();
    tecPassword.dispose();
  }

  toggleObscure() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  Future<void> login() async {
    try {
      XanX.showLoadingDialog();
      await Get.find<UserCredentialController>().login(un: tecUsername.text, pw: tecPassword.text);
      XanX.dismissLoadingDialog();
      Get.offAllNamed("/");
    } catch (e) {
      XanX.dismissLoadingDialog();
      XanX.handleErrorMessage(e);
    }
  }
}
