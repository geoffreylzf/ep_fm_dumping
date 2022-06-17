import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ep_fm_dumping/controllers/utils/network.dart';
import 'package:ep_fm_dumping/controllers/utils/user_credential.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

const BASE_LOCAL_URL = "http://192.168.8.1:8833";
const BASE_GLOBAL_URL = "http://epgroup.dyndns.org:8833";
const CONNECT_TIMEOUT = 30000;
const RECEIVE_TIMEOUT = 30000;

const UPDATE_APP_LOCAL_URL = "http://192.168.8.6";
const UPDATE_APP_GLOBAL_URL = "http://epgroup.dyndns.org:5031";

const _urlPrefix = "/eperp/index.php?r=";
const urlLogin = "${_urlPrefix}apiMobileAuth/NonGoogleAccLogin";
const urlLookup = "${_urlPrefix}apiMobileFmDumping/Lookup";
const urlSaveEntry = "${_urlPrefix}apiMobileFmDumping/SaveEntry";
const urlDeleteEntry = "${_urlPrefix}apiMobileFmDumping/DeleteEntry";

_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Api {
  late Dio _dioLocal, _dioGlobal;
  late Dio _dioUpdateAppLocal, _dioUpdateAppGlobal;

  static final _instance = Api._internal();

  factory Api() => _instance;

  Api._internal() {
    _dioLocal = Dio();
    _dioLocal.options.baseUrl = BASE_LOCAL_URL;
    _dioLocal.options.connectTimeout = CONNECT_TIMEOUT;
    _dioLocal.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dioLocal.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    _dioLocal.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        String token = Get.find<UserCredentialController>().getBasicCredential();
        options.headers["Authorization"] = token;
        handler.next(options);
      }),
    );
    _dioLocal.interceptors.add(LogInterceptor());

    _dioGlobal = Dio();
    _dioGlobal.options.baseUrl = BASE_GLOBAL_URL;
    _dioGlobal.options.connectTimeout = CONNECT_TIMEOUT;
    _dioGlobal.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dioGlobal.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    _dioGlobal.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        String token = Get.find<UserCredentialController>().getBasicCredential();
        options.headers["Authorization"] = token;
        handler.next(options);
      }),
    );
    //_dioGlobal.interceptors.add(LogInterceptor());

    _dioUpdateAppLocal = Dio();
    _dioUpdateAppLocal.options.baseUrl = UPDATE_APP_LOCAL_URL;
    _dioUpdateAppLocal.options.connectTimeout = CONNECT_TIMEOUT;
    _dioUpdateAppLocal.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dioUpdateAppLocal.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;

    _dioUpdateAppGlobal = Dio();
    _dioUpdateAppGlobal.options.baseUrl = UPDATE_APP_GLOBAL_URL;
    _dioUpdateAppGlobal.options.connectTimeout = CONNECT_TIMEOUT;
    _dioUpdateAppGlobal.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dioUpdateAppGlobal.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
  }

  Dio get dio {
    if (Get.find<NetworkController>().isLocal) {
      return _dioLocal;
    }
    return _dioGlobal;
  }

  Dio get updateAppDio {
    if (Get.find<NetworkController>().isLocal) {
      return _dioUpdateAppLocal;
    }
    return _dioUpdateAppGlobal;
  }
}
