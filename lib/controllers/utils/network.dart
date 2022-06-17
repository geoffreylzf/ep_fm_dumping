import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const NT_LOCAL = "NT_LOCAL";

class NetworkController extends GetxController {
  final rxIsLocal = true.obs;
  var isLocal = true;
  late SharedPreferences _sp;

  @override
  void onInit() async {
    super.onInit();
    _sp = await SharedPreferences.getInstance();
    rxIsLocal.value = _sp.getBool(NT_LOCAL) ?? true;
    isLocal = rxIsLocal.value;
  }

  void toggleLocal() async {
    await _sp.setBool(NT_LOCAL, !rxIsLocal.value);
    rxIsLocal.value = !rxIsLocal.value;
    isLocal = rxIsLocal.value;
  }
}
