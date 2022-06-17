import 'package:ep_fm_dumping/controllers/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalCheckBox extends StatelessWidget {
  LocalCheckBox({Key? key}) : super(key: key);
  final ctrl = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ctrl.toggleLocal();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Checkbox(
              value: ctrl.rxIsLocal.value,
              onChanged: (bool? b) {
                ctrl.toggleLocal();
              },
            ),
          ),
          const Flexible(
            fit: FlexFit.loose,
            child: Text(
              "Local (Connect Office Wi-Fi)",
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
