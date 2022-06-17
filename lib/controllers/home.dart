import 'package:ep_fm_dumping/models/fm_prod_dumping.dart';
import 'package:ep_fm_dumping/modules/api.dart';
import 'package:ep_fm_dumping/utils/xanx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final tecDumpingDate = TextEditingController();
  final dateFormat = DateFormat('yyyy-MM-dd');

  final rxFmProdDumpingList = Rx<List<FmProdDumping>>([]);

  @override
  void onInit() async {
    super.onInit();
    final today = dateFormat.format(DateTime.now());

    tecDumpingDate.text = today;
    tecDumpingDate.addListener(() {
      loadDumpingList(tecDumpingDate.text);
    });

    loadDumpingList(today, isShowDialog: false);
  }

  @override
  void onClose() {
    tecDumpingDate.dispose();
  }

  loadDumpingList(dateStr, {bool isShowDialog = true}) async {
    try {
      if (isShowDialog) XanX.showLoadingDialog();
      final res = await Api().dio.get(
        urlLookup,
        queryParameters: {'type': 'dumping_list', 'dumping_date': dateStr},
      );
      rxFmProdDumpingList.value = (res.data as List).map((e) => FmProdDumping.fromJson(e)).toList();
      if (isShowDialog) XanX.dismissLoadingDialog();
    } catch (e) {
      if (isShowDialog) XanX.dismissLoadingDialog();
      if (!isShowDialog) await Future.delayed(const Duration(seconds: 1));
      XanX.handleErrorMessage(e);
    }
  }

  refreshDumpingList() async {
    await loadDumpingList(tecDumpingDate.text);
  }

  void gotoDump(FmProdDumping dump) {
    Get.toNamed("/dumps/${dump.id}");
  }
}
