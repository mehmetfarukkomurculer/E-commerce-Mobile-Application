import 'package:flutter/cupertino.dart';

class MyAlertDialog{
  static void showMyDialog(
      {required BuildContext context,
        required String title,
        required String content,
        required Function() tabno,
        required Function() tabyes,
      }){
    showCupertinoDialog<void>(context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(child: const Text('No'),
              onPressed: tabno,
            ),
            CupertinoDialogAction(child: const Text('Yes'),
              onPressed: tabyes,
            ),
          ],
        ));
  }
}