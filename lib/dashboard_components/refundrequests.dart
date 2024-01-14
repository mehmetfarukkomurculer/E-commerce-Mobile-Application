import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:untitled3/models/refund_requests_model.dart';

class RefundRequests extends StatelessWidget {
  const RefundRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> reviewStream = FirebaseFirestore.instance
        .collection('refundRequests')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Refund Requests',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reviewStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return const Text('Something went wrong');
          }if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }if(snapshot.data!.docs.isEmpty){
            return const Center(
              child: Text(
                'There is no any refund requests',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
            );
          }return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 1,
              itemBuilder: (context, index){
                return RefundRequestsModel(requests: snapshot.data!.docs[index]);
              },
              staggeredTileBuilder: (context)=> const StaggeredTile.fit(1),
            ),
          );
        },
      ),
    );
  }
}