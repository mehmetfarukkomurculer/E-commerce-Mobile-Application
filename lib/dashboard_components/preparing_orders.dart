import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/models/deliverystatus_model.dart';

class Preparing extends StatelessWidget {
  const Preparing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('deliverystatus', isEqualTo: 'preparing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
        if(snapshot.hasError){
          return const Text('Something went wrong');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.data!.docs.isEmpty){
          return const Center(
            child: Text(
              'There is no order \n\n in preparing status!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index){
            return DeliveryStatusModel(order: snapshot.data!.docs[index]);
          },
        );
      },
    );
  }
}
