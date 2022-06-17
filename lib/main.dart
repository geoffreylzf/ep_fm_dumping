import 'package:ep_fm_dumping/controllers/utils/network.dart';
import 'package:ep_fm_dumping/controllers/utils/user_credential.dart';
import 'package:ep_fm_dumping/pages/dumps/_id/add_workers.dart';
import 'package:ep_fm_dumping/pages/dumps/_id/index.dart';
import 'package:ep_fm_dumping/pages/home.dart';
import 'package:ep_fm_dumping/pages/login.dart';
import 'package:ep_fm_dumping/pages/setting.dart';
import 'package:ep_fm_dumping/pages/splash.dart';
import 'package:ep_fm_dumping/pages/update_app_ver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NetworkController());
    Get.put(UserCredentialController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Eng Peng Feedmill Dumping',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.indigoAccent,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/setting', page: () => const SettingPage()),
        GetPage(name: '/updateAppVer', page: () => const UpdateAppVerPage()),
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/dumps/:id', page: () => DumpIdIndexPage()),
        GetPage(name: '/dumps/:id/add-workers', page: () => DumpIdIndexAddWorkersPage()),
      ],
    );
  }
}
