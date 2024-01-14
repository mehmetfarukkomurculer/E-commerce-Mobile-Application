import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/dashboard_components/add_product.dart';
import 'package:untitled3/dashboard_components/remove_product.dart';
import 'package:untitled3/dashboard_components/approve_comments.dart';
import 'package:untitled3/dashboard_components/delivery_status.dart';
import 'package:untitled3/dashboard_components/stats.dart';

import '../widgets/alertdialog.dart';

List<String> labels = [
  'Approve Comments',
  'Add Products',
  'Remove Products',
  'Delivery Status',
  'Stats',
];

List<IconData> icons = [
  Icons.comment,
  Icons.add,
  Icons.folder_delete_outlined,
  Icons.change_circle,
  Icons.auto_graph,
];

List<Widget> pages2 = const [
  ApproveComments(),
  AddProduct(),
  RemoveProduct(),
  DeliveryStatus(),
  Stats(),
];


class ProductManagerDashboardScreen extends StatelessWidget {
  const ProductManagerDashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
            List.generate(5, (index){
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => pages2[index]));
                },
                child: Card(
                  elevation: 10,
                  color: Colors.blueAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        icons[index],
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(labels[index].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
            ),
              );
          })
      ),
    );
  }
}
