import 'package:dio/dio.dart';
import 'package:ep_fm_dumping/utils/ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XanX {
  static showErrorDialog({String title = "Error", required String message}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("CLOSE"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  static showConfirmDialog({
    required String title,
    required String message,
    required String btnPositiveText,
    required VoidCallback vcb,
    btnNegativeText = 'Cancel',
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(btnNegativeText.toUpperCase()),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text(btnPositiveText.toUpperCase()),
            onPressed: () {
              vcb();
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static showLoadingDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 10,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static dismissLoadingDialog() {
    Get.back();
  }

  static showAlertDialog({String title = 'Info', required String message}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("CLOSE"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }

  static handleErrorMessage(dynamic e) {
    if (e is DioError) {
      XanX.showErrorDialog(
        title: "Network Error",
        message: e.formatApiErrorMsg(),
      );
    } else {
      XanX.showErrorDialog(
        title: "Unexpected Error",
        message: e.toString(),
      );
    }
  }
}
