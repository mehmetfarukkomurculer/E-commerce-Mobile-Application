import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/dashboard_components/refundrequests.dart';
import 'package:untitled3/dashboard_components/setdiscount.dart';
import '../widgets/alertdialog.dart';

List<String> labels = [
  'Set Discount For Products',
  'Refund Requests'
];

List<IconData> icons = [
  Icons.settings_applications_rounded,
  Icons.request_page,
];

List<Widget> pages = const [
  SetDiscount(),
  RefundRequests(),
];


class SalesManagerDashboardScreen extends StatelessWidget {
  const SalesManagerDashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        title: const Text(
            'Dashboard'
        ),
        actions: [
          IconButton(
            onPressed: (){
              MyAlertDialog.showMyDialog(
                  context: context,
                  title: 'Log out',
                  content: 'Are you sure to log out?',
                  tabno: (){Navigator.pop(context);},
                  tabyes: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, '/welcome_screen');
                  });
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: GridView.count(
          crossAxisCount: 2,
          children:
          List.generate(2, (index){
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Card(
                margin: const EdgeInsets.fromLTRB(16.0,12.0,16.0,8.0),
                elevation: 10,
                color: Colors.lightGreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      size: 50,
                      color: Colors.white,
                    ),
                    Text(
                      labels[index].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                    ),
                  ],
                ),
              ),
            );
          })
      ),
    );
  }
}
