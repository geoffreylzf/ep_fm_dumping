import 'dart:convert';

import 'package:ep_fm_dumping/controllers/home.dart';
import 'package:ep_fm_dumping/models/fm_person_worker.dart';
import 'package:ep_fm_dumping/models/fm_prod_dumping.dart';
import 'package:ep_fm_dumping/models/fm_prod_dumping_entry_worker.dart';
import 'package:ep_fm_dumping/models/store.dart';
import 'package:ep_fm_dumping/modules/api.dart';
import 'package:ep_fm_dumping/utils/xanx.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DumpIdIndexController extends GetxController {
  final id = int.parse(Get.parameters['id']!);

  final timeFormat = DateFormat('HH:mm:ss');

  final rxStoreList = Rx<List<Store>>([]);
  final rxFmProdDumping = Rx<FmProdDumping?>(null);
  final rxIsCreate = Rx<bool>(false);

  final formKey = GlobalKey<FormState>();
  final tecBucketQtyTtl = TextEditingController();
  final tecBagQtyTtl = TextEditingController();
  final tecTimeStart = TextEditingController();
  final tecTimeEnd = TextEditingController();

  final rxFmPersonWorkerList = Rx<List<FmPersonWorker>>([]);

  final rxSelectedStoreId = Rx<int?>(null);

  @override
  void onInit() async {
    super.onInit();

    await loadDumping(isShowDialog: false);
  }

  @override
  void onClose() {
    tecBucketQtyTtl.dispose();
    tecBagQtyTtl.dispose();
    tecTimeStart.dispose();
    tecTimeEnd.dispose();
  }

  loadDumping({bool isShowDialog = true}) async {
    try {
      if (isShowDialog) XanX.showLoadingDialog();

      final resStoreList = await Api().dio.get(
        urlLookup,
        queryParameters: {'type': 'store_list'},
      );

      /// remove existing workers
      final storeList = (resStoreList.data as List).map((e) => Store.fromJson(e)).toList();
      storeList.add(Store(null, "-", "-"));
      rxStoreList.value = storeList;

      final resDump = await Api().dio.get(
        urlLookup,
        queryParameters: {'type': 'dump', 'id': id},
      );
      rxFmProdDumping.value = FmProdDumping.fromJson(resDump.data);
      final dump = rxFmProdDumping.value;

      rxSelectedStoreId.value = rxFmProdDumping.value!.storeId;
      tecBucketQtyTtl.text = dump?.bucketQtyTtl?.toString() ?? "";
      tecBagQtyTtl.text = dump?.bagQtyTtl?.toString() ?? "";
      tecTimeStart.text = dump?.timeStart?.toString() ?? "";
      tecTimeEnd.text = dump?.timeEnd?.toString() ?? "";

      if (dump!.entryId == null) {
        rxIsCreate.value = true;
      }

      if (isShowDialog) XanX.dismissLoadingDialog();
    } catch (e) {
      if (isShowDialog) XanX.dismissLoadingDialog();
      if (!isShowDialog) await Future.delayed(const Duration(seconds: 1));
      XanX.handleErrorMessage(e);
    }
  }

  void deleteWorker(FmProdDumpingEntryWorker wk) {
    rxFmProdDumping.value?.workers.remove(wk);
    rxFmProdDumping.refresh();
  }

  void gotoAddWorkersPage() async {
    try {
      final res = await Api().dio.get(
        urlLookup,
        queryParameters: {'type': 'worker_list'},
      );

      /// remove existing workers
      final wkList = (res.data as List).map((e) => FmPersonWorker.fromJson(e)).toList();
      final l = wkList.length;
      final existIdList =
          rxFmProdDumping.value?.workers.map((e) => e.fmPersonWorkerId).toList() ?? [];

      for (int i = l - 1; i >= 0; i--) {
        final wk = wkList[i];
        if (existIdList.contains(wk.id)) {
          wkList.remove(wk);
        }
      }

      rxFmPersonWorkerList.value = wkList;

      Get.toNamed("${Get.currentRoute}/add-workers");
    } catch (e) {
      XanX.handleErrorMessage(e);
    }
  }

  toggleWorkerSelection(FmPersonWorker wk) {
    wk.toggleSelect();
    rxFmPersonWorkerList.refresh();
  }

  insertSelectedWorkers() {
    final selList = rxFmPersonWorkerList.value.where((e) => e.isSelected).toList();
    for (final wk in selList) {
      rxFmProdDumping.value!.workers.add(FmProdDumpingEntryWorker(
        fmPersonWorkerId: wk.id,
        workerCode: wk.workerCode,
        workerName: wk.workerName,
      ));
    }
    rxFmProdDumping.refresh();
    Get.back();
  }

  void saveEntry() async {
    try {
      XanX.showLoadingDialog();

      rxFmProdDumping.value!.storeId = rxSelectedStoreId.value;
      rxFmProdDumping.value!.bucketQtyTtl = double.tryParse(tecBucketQtyTtl.text);
      rxFmProdDumping.value!.bagQtyTtl = int.tryParse(tecBagQtyTtl.text);
      rxFmProdDumping.value!.timeStart = tecTimeStart.text;
      rxFmProdDumping.value!.timeEnd = tecTimeEnd.text;

      final json = rxFmProdDumping.value!.toEntryJson();
      final jsonStr = jsonEncode(json);
      await Api().dio.post(urlSaveEntry, data: jsonStr);
      XanX.dismissLoadingDialog();
      Fluttertoast.showToast(msg: "Saved");

      Get.find<HomeController>().refreshDumpingList();
      Get.back();
    } catch (e) {
      XanX.dismissLoadingDialog();
      XanX.handleErrorMessage(e);
    }
  }

  void deleteEntry() async {
    try {
      XanX.showLoadingDialog();

      await Api().dio.post(urlDeleteEntry, data: {"entry_id": rxFmProdDumping.value!.entryId});
      XanX.dismissLoadingDialog();
      Fluttertoast.showToast(msg: "Deleted");

      Get.find<HomeController>().refreshDumpingList();
      Get.back();
    } catch (e) {
      XanX.dismissLoadingDialog();
      XanX.handleErrorMessage(e);
    }
  }
}
