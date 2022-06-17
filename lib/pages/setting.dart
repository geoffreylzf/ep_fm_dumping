import 'package:ep_fm_dumping/controllers/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          LocalTitle(),
          const Divider(height: 0),
          const VersionTile(),
        ],
      ),
    );
  }
}

class LocalTitle extends StatelessWidget {
  LocalTitle({Key? key}) : super(key: key);

  final ctrl = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: const Text("Local Network"),
      subtitle: const Text("Tick this when using EP Group Wi-Fi"),
      trailing: Obx(
        () => Switch(
          value: ctrl.rxIsLocal.value,
          onChanged: (bool b) {
            ctrl.toggleLocal();
          },
        ),
      ),
    );
  }
}

class VersionTile extends StatelessWidget {
  const VersionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: const Text("Application Version"),
      subtitle: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (ctx, snapshot) {
          var version = "";
          if (snapshot.hasData) {
            version = snapshot.data?.version ?? "";
          }
          return Text(version);
        },
      ),
    );
    ;
  }
}
