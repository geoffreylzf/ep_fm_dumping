import 'package:ep_fm_dumping/modules/api.dart';
import 'package:ep_fm_dumping/utils/xanx.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppVerController extends GetxController {
  final verCode = 0.obs;
  final verName = ''.obs;
  final appCode = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    final PackageInfo info = await PackageInfo.fromPlatform();

    verCode.value = int.tryParse(info.buildNumber) ?? 0;
    verName.value = info.version;
    appCode.value = info.packageName;
  }

  void updateApp() async {
    final url = "/api/info/mobile/apps/${appCode.value}/latest";
    try {
      XanX.showLoadingDialog();
      final res = await Api().updateAppDio.get(url);
      final latestVerCode = int.tryParse(res.data['version_code'].toString()) ?? 0;
      final latestVerDownloadLink = res.data['download_link'].toString();
      XanX.dismissLoadingDialog();

      if (latestVerCode > verCode.value) {
        if (await canLaunch(latestVerDownloadLink)) {
          await launch(latestVerDownloadLink);
        } else {
          XanX.showErrorDialog(message: "Cannot launch download apk url");
        }
      } else if (latestVerCode == verCode.value) {
        XanX.showAlertDialog(message: "Current app is the latest version");
      } else {
        XanX.showErrorDialog(
            message: "Current Ver : ${verCode.value} \nLatest Ver : $latestVerCode");
      }
    } catch (e) {
      XanX.dismissLoadingDialog();
      XanX.handleErrorMessage(e);
    }
  }
}
