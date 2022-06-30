import 'dart:convert';

import 'package:ep_fm_dumping/modules/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USERNAME = "UC_USERNAME";
const PASSWORD = "UC_PASSWORD";

class UserCredentialController extends GetxController {
  final isInitializing = true.obs;
  final username = ''.obs;

  String? _username, _password;
  bool isLogged = false;
  late SharedPreferences _sp;

  @override
  void onInit() async {
    super.onInit();
    ever(isInitializing, (_) {
      if (isLogged) {
        Get.offAllNamed("/");
      } else {
        Get.offAllNamed("/login");
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    _sp = await SharedPreferences.getInstance();
    _username = _sp.getString(USERNAME);
    _password = _sp.getString(PASSWORD);

    if (_username != null && _password != null) {
      username.value = _username!;
      isLogged = true;
    }
    isInitializing.value = false;
  }

  Future<void> setCredentialInfo(String un, String pw) async {
    _username = un;
    _password = pw;
    username.value = _username!;
    await _sp.setString(USERNAME, un);
    await _sp.setString(PASSWORD, pw);
  }

  Future<void> clearCredentialInfo() async {
    _username = null;
    _password = null;
    await _sp.remove(USERNAME);
    await _sp.remove(PASSWORD);
  }

  Future<void> login({String? un, String? pw}) async {
    un = un ?? _username;
    pw = pw ?? _password;

    try {
      await setCredentialInfo(un!, pw!);
      final res = await Api().dio.post(urlLogin);
      if (res.data["cod"] != 200){
        throw Exception("Authentication Failed");
      }
    } catch (e) {
      await clearCredentialInfo();
      rethrow;
    }
  }

  String getBasicCredential() {
    return 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';
  }

  Future<void> signOut() async {
    _username = null;
    _password = null;
    await _sp.remove(USERNAME);
    await _sp.remove(PASSWORD);
    isLogged = false;
    Get.offAllNamed("/login");
  }
}
