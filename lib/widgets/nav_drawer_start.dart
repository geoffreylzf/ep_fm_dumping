import 'package:ep_fm_dumping/controllers/utils/user_credential.dart';
import 'package:ep_fm_dumping/utils/xanx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavDrawerStart extends StatelessWidget {
  const NavDrawerStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserCredentialController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Icon(Icons.account_circle, color: Colors.white),
                          ),
                          Obx(() => Text(
                                ctrl.username.value,
                                style: const TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () async {
              Get.toNamed("/setting");
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.update),
            title: const Text('Update App Version'),
            onTap: () async {
              Get.toNamed("/updateAppVer");
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign out'),
            onTap: () async {
              XanX.showConfirmDialog(
                title: 'Sign out',
                message: "Are you confirm?",
                btnPositiveText: 'Sign out',
                vcb: () async {
                  ctrl.signOut();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
