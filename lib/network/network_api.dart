import 'package:dio/dio.dart';
import 'package:fin_xp/configs/session.dart';
import 'package:fin_xp/configs/styles.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: true,
  ),
);

class NetworkAPI {
  var endpoint = "";
  Map<String, dynamic> jsonQuery = {};
  FormData formData;
  NetworkAPI({
    this.endpoint,
    this.jsonQuery,
    this.formData,
  });
  var dio = Dio(
    BaseOptions(
        baseUrl: Session.shared.getBaseURL(),
        connectTimeout: 1000000, //1000 = 1s
        receiveTimeout: 50000),
  );

  Future callAPIGET({showLog = false, keepKeyboard = false}) async {
    return callAPI(showLog: showLog, keepKeyboard: keepKeyboard, method: "GET");
  }

  Future callAPIPOST({showLog = false, keepKeyboard = false}) async {
    return callAPI(showLog: showLog, keepKeyboard: keepKeyboard);
  }

  Future callAPI(
      {method = "POST",
      showLog = false,
      keepKeyboard = false,
      Function(double) percent}) async {
    if (keepKeyboard == false) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }

    Response response;
    var fullUrl = '${Session.shared.getBaseURL()}$endpoint';
    printApp("FullURL: $fullUrl");
    printApp("jsonQuery: $jsonQuery");
    var token = await Session.shared.getToken();
    dio.options.headers["Authorization"] = "Bearer " + token;

    dio.interceptors.add(LogInterceptor(responseBody: true));
    try {
      if (method == "POST") {
        if (formData?.fields != null) {
          printApp('🍎 🍎 🍎 formData =====> ${formData.fields}');
        }

        response = await dio.post(
          endpoint,
          queryParameters: jsonQuery,
          data: formData != null ? formData : null,
          onSendProgress: (int sent, int total) {
            if (percent != null) {
              var perCent = sent.toDouble() / total.toDouble();
              percent(perCent);
            }
            // printApp('$sent/$total');
            // printApp('$sent/$total');
            // var perCent = sent.toDouble()/total.toDouble();
            // percent(perCent);
          },
        );
      } else {
        response = await dio.get(endpoint, queryParameters: jsonQuery);
      }

      // if (showLog) {
      //   // logger.d(response.request.data.toString());
      //   logger.d(jsonQuery);
      //   logger.d(response.data);
      //   // printApp("response pure $response");
      //   // logger.d(response.data);
      // }
      if (jsonQuery != null) {
        logger.d(jsonQuery);
      }
      // if (formData != null) {
      //   logger.d(formData.fields);
      // }
      // if (response.data != null) {
      //   logger.d(response.data);
      // }
      if (response.statusCode == 200) {
        printApp("$fullUrl ✅");
        return response.data;
      } else {
        // return handleAPIError(response);

        printApp("POST $fullUrl ❌ => ${response.data}");

        return response.data;
      }
    } on DioError catch (e) {
      Session.shared.hideLoading();
      printApp("❌❌❌❌❌❌error PURE ${e.message}");

      if(e.message.contains("Failed host lookup")){
        Session.shared.showAlertPopupOneButtonNoCallBack(
            content: "Internet may not be available! Please check internet connection and try again");

      }

      var errorString = e.response.data['name'] ?? e.message.toString();
      if (errorString == 'Unauthorized') {
        printApp(
            "$method $fullUrl ❌❌ => Session expire"); //for showing only here
        // Session.shared.showAlertPopupOneButtonNoCallBack(
        //     content: "$fullUrl ${e.response.statusCode } Not found");

        Session.shared.showAlertPopupOneButtonNoCallBack(
            content: "Your request was made with invalid credentials.");
        // return e.response.data;
      } else {
        printApp(
            "$method $fullUrl ❌❌ => ${errorString}"); //for showing only here

        return e.response.data;
      }
    }
  }
}
