import 'package:ep_fm_dumping/controllers/update_app_ver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateAppVerPage extends StatelessWidget {
  const UpdateAppVerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(UpdateAppVerController());

    return Scaffold(
      appBar: AppBar(title: const Text('Update App Version')),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Version Code : ${ctrl.verCode.value}"),
              Text("Version Name : ${ctrl.verName.value}"),
              ElevatedButton.icon(
                onPressed: () => ctrl.updateApp(),
                icon: const Icon(Icons.update),
                label: const Text("UPDATE APP VERSION"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
