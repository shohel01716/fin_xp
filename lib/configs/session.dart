
import 'package:fin_xp/configs/styles.dart';
import 'package:fin_xp/widgets/alertbox_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config_setting.dart';
import 'strings.dart';

class Session {
  static final Session _singleton = Session._internal();
  factory Session() {
    return _singleton;
  }

  Session._internal();

  final box = GetStorage();
  static Session get shared => _singleton;
  // variables


  getBaseURL() {
    var _baseURL = ConfigSetting.baseURLFirstload;
    if (_baseURL.endsWith('/')) {
      return _baseURL;
    } else {
      return _baseURL + '/';
    }
  }

  get widthScreen => Get.width;

  showLoading() {
    if (!EasyLoading.isShow) {
      EasyLoading.show();
    }

  }

  showLoadingV2() {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: true);
  }

  hideLoading() {
    EasyLoading.dismiss();
  }

  hideLoadingV2() {
    Get.back();
  }

  //
  showAlertPopupOneButtonNoCallBack({String title = 'Error', String content}) {

    Get.dialog(AlertPopupOneButton(title: title, content: content),
        barrierDismissible: false);

  }

  //
  showAlertPopupOneButtonWithCallback(
      {String title = 'Error', String content = '', Function callback}) {
    if (!Get.isDialogOpen) {
      if (content == "Your request was made with invalid credentials.") {
        Get.dialog(
            AlertPopupOneButton(
                title: "Session expire",
                content: "Please login again",
                callbackAfterPressOK: () {

                }),
            barrierDismissible: false);
      } else {
        Get.dialog(
            AlertPopupOneButton(
                title: title, content: content, callbackAfterPressOK: callback),
            barrierDismissible: false);
      }
    }

    //check session expire here !
  }

  showAlertPopup2ButtonWithCallback(
      {String title = '',
      String content = '',
      Function callback,
      String titleButtonRight = "OK",
      String titleButtonLeft = "Cancel"}) {
    Get.dialog(AlertPopup2Button(
        title: title,
        content: content,
        callbackAfterPressOK: callback,
        titleButtonRight: titleButtonRight,
        titleButtonLeft: titleButtonLeft));
  }

  showAlertPopup2ButtonWith2Callback(
      {String title = '',
      String content = '',
      Function() callbackButtonRight,
      Function() callbackButtonLeft,
      String titleButtonRight = "OK",
      String titleButtonLeft = "Cancel"}) {
    Get.dialog(AlertPopup2ButtonCallback(
        title: title,
        content: content,
        callbackButtonRight: callbackButtonRight,
        callbackButtonLeft: callbackButtonLeft,
        titleButtonRight: titleButtonRight,
        titleButtonLeft: titleButtonLeft));
  }

  showAlertPopupWithCallbackTextFieldInput(
      {bool obscureText = false,
      String title = "",
      String cancleText = 'Cancle',
      String placeholder = '',
      String confirmText = 'OK',
      Function(String) callback}) {
    Get.dialog(AlertPopupWithTextField(
      title: title,
      obscureText: obscureText,
      placeholder: placeholder,
      confirmText: confirmText,
      cancleText: cancleText,
      callbackAfterPressOK: (textInput) {
        callback(textInput);
      },
    ));
  }

  getToken() async {
    var tk = await box.read(Strings.token) ?? "";
    printApp("🍎 token from box! $tk");
    return tk;
  }

  saveToken(String newToken) async {
    box.write(Strings.token, newToken);
    printApp("🍎saved token to box! $newToken");
  }

  clearToken() async {
    await box.remove(Strings.token);
    printApp("🍎delete token");
  }

  convertToInt({dynamic data}) {
    if (data is String) {
      return int.tryParse(data) ?? 0;
    }
    if (data is int) {
      return data;
    }
  }

  logout() async {
    Get.reset();
    await clearToken();
  }
}
