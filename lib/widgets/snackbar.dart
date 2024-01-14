import 'package:flutter/material.dart';

class MyMessageHandler{
  static void showSnackBar(var _scaffoldkey, String message){
    _scaffoldkey.currentState!.hideCurrentSnackBar();
    _scaffoldkey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style:
          const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        )));
  }
}