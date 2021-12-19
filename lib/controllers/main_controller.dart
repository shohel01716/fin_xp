import 'package:fin_xp/configs/config_setting.dart';
import 'package:fin_xp/configs/session.dart';
import 'package:fin_xp/configs/styles.dart';
import 'package:fin_xp/configs/url_app.dart';
import 'package:fin_xp/models/LoginModelResult.dart';
import 'package:fin_xp/network/network_api.dart';
import 'package:fin_xp/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as Dioo;

class MainController extends GetxController {
  final localStorage = GetStorage();

  var loginModelResult = LoginModelResult().obs;
  var balance = 0.0.obs;
  var loginEmailController = TextEditingController();
  var loginPasswordController = TextEditingController();

  @override
  void onInit() {

    super.onInit();
  }

  callAPILogin({
    showLoading: true,
    int sessionId, Function callbackDone}) async {
    printApp("✅ start callAPILogin");

    ConfigSetting.baseURLFirstload = ConfigSetting.baseURLLogin;
    Session.shared.getBaseURL();

    if(loginEmailController.text.isEmpty){
      Session.shared.showAlertPopupOneButtonNoCallBack(
          content: "Email cannot be empty!");
      return;
    }

    if(!isEmail(loginEmailController.text)){
      Session.shared.showAlertPopupOneButtonNoCallBack(
          content: "Enter valid email!");
      return;
    }

    if(loginPasswordController.text.isEmpty){
      Session.shared.showAlertPopupOneButtonNoCallBack(
          content: "Password cannot be empty!");
      return;
    }

    if (showLoading) Session.shared.showLoading();

    var formData = Dioo.FormData();
    formData.fields.add(MapEntry('email', loginEmailController.text));
    formData.fields.add(MapEntry('password', loginPasswordController.text));

    var network = NetworkAPI(endpoint: url_login, formData: formData);
    var jsonBody = await network.callAPIPOST(showLog: true);
    if (showLoading) Session.shared.hideLoading();
    if (jsonBody["code"] == null) {

      EasyLoading.showSuccess("Login successful");

      printApp("success $jsonBody");
      var result = LoginModelResult.fromJson(jsonBody);
      loginModelResult.value = result;

      await Session.shared.saveToken(jsonBody["access_token"]);

      printApp(jsonBody["refresh_token"]);

      callAPIBalance();

      if(callbackDone!=null)
      callbackDone();
      //refresh
    } else {
      printApp("❌❌❌error $url_login $jsonBody");
      Session.shared.showAlertPopupOneButtonNoCallBack(
          content: jsonBody["message"]);
    }
  }

  callAPIBalance({
    showLoading: false,
    int sessionId, Function callbackDone}) async {
    printApp("✅ start callAPIBalance");

    ConfigSetting.baseURLFirstload = ConfigSetting.baseURLBalance;
    Session.shared.getBaseURL();

    if (showLoading) Session.shared.showLoading();

    var network = NetworkAPI(endpoint: url_balance);
    var jsonBody = await network.callAPIGET(showLog: true);
    if (showLoading) Session.shared.hideLoading();
    if (jsonBody["code"] == 200) {
      printApp("success $jsonBody");
      balance.value = jsonBody["data"]["balance"];
      if(callbackDone!=null)
        callbackDone();
      //refresh
    } else {
      printApp("❌❌❌error $url_login $jsonBody");
      Session.shared.showAlertPopupOneButtonNoCallBack(
          content: jsonBody["message"]);
    }
  }

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}