import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:untitled3/models/set_discount_model.dart';

class SetDiscount extends StatelessWidget {
  const SetDiscount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          'Set Discount',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
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
                'There is no item to set discount!',
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
                return SetDiscountModel(products: snapshot.data!.docs[index]);
              },
              staggeredTileBuilder: (context)=> const StaggeredTile.fit(1),
            ),
          );
        },
      ),
    );
  }
}