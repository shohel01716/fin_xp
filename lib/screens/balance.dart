import 'package:fin_xp/configs/theme.dart';
import 'package:fin_xp/controllers/main_controller.dart';
import 'package:fin_xp/widgets/snackbar.dart';
import 'package:flutter/material.dart';


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {

  MainController mainController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: Get.height *.015,),
          Obx(() => Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Image.asset("assets/images/man.png"),
              trailing: Image.asset("assets/icons/icon.png"),
              title: Text("Shohel Rana"),
              subtitle: Text("Balance: ${mainController.balance.value}€"),
            ),
          )),
        ],
      ),
    );
  }
}
