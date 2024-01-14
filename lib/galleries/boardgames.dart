import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:untitled3/models/product_model.dart';

class BoardGames extends StatefulWidget {
  const BoardGames({Key? key}) : super(key: key);

  @override
  State<BoardGames> createState() => _BoardGamesState();
}

class _BoardGamesState extends State<BoardGames> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: 'Board Games')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
              'This category \n\n has no items!',
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
            crossAxisCount: 2,
            itemBuilder: (context, index){
              return ProductModel(products: snapshot.data!.docs[index]);
            },
            staggeredTileBuilder: (context)=> const StaggeredTile.fit(1),
          ),
        );
      },
    );
  }
}