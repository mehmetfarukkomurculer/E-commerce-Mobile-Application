import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:untitled3/providers/wishlist_provider.dart';
import 'package:untitled3/screens/cart.dart';
import 'package:untitled3/widgets/snackbar.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart';
import 'package:expandable/expandable.dart';


class ProductDetailsScreen extends StatefulWidget {
  final dynamic productList;

  const ProductDetailsScreen({Key? key, required this.productList}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: widget.productList['category'])
      .snapshots();
  late final Stream<QuerySnapshot> reviewStream = FirebaseFirestore.instance
      .collection('reviews')
      .where('product', isEqualTo: widget.productList['id']).where('approved', isEqualTo: true)
      .snapshots();



  final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.productList['images'];
  @override
  Widget build(BuildContext context) {
    var existingItemCart = context
        .read<Cart>()
        .getItems
        .firstWhereOrNull((productDeclare) => productDeclare.documentID == widget.productList['id']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldkey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Swiper(
                          pagination: const SwiperPagination(builder: SwiperPagination.fraction),
                            itemBuilder: (context, index){
                              return Image(
                                  image: NetworkImage(
                                    imagesList[index],
                                  ),
                              );
                            },
                            itemCount: imagesList.length,
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,),
                            onPressed: (){
                              Navigator.pop(context);
                              },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                      widget.productList['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  int.parse(widget.productList['discount']) != 0
                      ? Padding(
                    padding: const EdgeInsets.all(8),
                        child: Container(
                          width: 150,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.yellowAccent,
                          ),
                          child: Center(
                            child: Text('Discount: ' + widget.productList['discount'] + ' %',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ) : Container(
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  'Price: '+ (double.parse(widget.productList['sellPrice'].toString())).toString() + ' ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                              const Text(
                                  "\$",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              int.parse(widget.productList['discount']) != 0
                                  ? Text((double.parse(widget.productList['actualPrice'].toString())).toStringAsFixed(2)  + ('\$'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                                  : Container(color: Colors.transparent),
                            ],
                        ),
                        SizedBox(
                          height: 60,
                          width: 30,
                          child: IconButton(
                            onPressed: (){
                              var existingItemWishlist = context
                                  .read<Wishlist>()
                                  .getWishlistItems
                                  .firstWhereOrNull(
                                      (productDeclare) => productDeclare.documentID == widget.productList['id']);
                               existingItemWishlist != null
                                  ? context.read<Wishlist>().removeThis(widget.productList['id'])
                                  : context.read<Wishlist>().addWishlistItem(
                                      widget.productList['name'].toString(),
                                      double.parse(widget.productList['sellPrice'].toString()),
                                      1,
                                      int.parse(widget.productList['stock'].toString()),
                                      widget.productList['images'],
                                      widget.productList['id'].toString(),
                                      widget.productList['email'].toString(),
                                      widget.productList['category'],
                              );
                            },
                            icon: context.watch<Wishlist>().getWishlistItems.firstWhereOrNull((productDeclare) =>
                            productDeclare.documentID == widget.productList['id']) != null
                                ? const Icon(
                              Icons.favorite,
                              color: Colors.red)
                                : const Icon(
                              Icons.favorite_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  int.parse(widget.productList['stock']) == 0 
                      ? const Text('This item is out of stock', style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),)
                      :Text(
                      'Remaining stock for this collectible: ' + widget.productList['stock'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const ProductDetailHeaderLabel(label: '  Item Description  '),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                            widget.productList['des'],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.productList['shortDes'],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  reviews(reviewStream),
                  const ProductDetailHeaderLabel(label: '  Similar Collectibles  '),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
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
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: (){}, icon: const Icon(Icons.store)),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
                      }, icon: Badge(
                          showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
                          padding: const EdgeInsets.all(3.5),
                          badgeContent: Text(
                              context.watch<Cart>().getItems.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Icon(Icons.shopping_cart),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.purple, borderRadius: BorderRadius.circular(25),
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        var existingItemCart = context
                            .read<Cart>()
                            .getItems
                            .firstWhereOrNull((productDeclare) => productDeclare.documentID == widget.productList['id']);

                        if(int.parse(widget.productList['stock']) == 0){
                          MyMessageHandler.showSnackBar(_scaffoldkey, 'This item is out of stock!');
                        }else if(existingItemCart != null){
                          MyMessageHandler.showSnackBar(_scaffoldkey, 'This item already exists in your cart!');
                        }else{
                          context.read<Cart>().addItem(
                            widget.productList['name'].toString(),
                            double.parse(widget.productList['sellPrice'].toString()),
                            1,
                            int.parse(widget.productList['stock'].toString()),
                            widget.productList['images'],
                            widget.productList['id'].toString(),
                            widget.productList['email'].toString(),
                            widget.productList['category'].toString(),
                          );
                        }
                      },
                      child: int.parse(widget.productList['stock']) == 0
                          ? const Text(' OUT OF STOCK')
                      :Text(existingItemCart != null
                          ? 'ADDED'
                          : 'ADD TO CART',
                        style: const TextStyle(
                        color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailHeaderLabel extends StatelessWidget {
  final String label;
  const ProductDetailHeaderLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.purple,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.purple,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(var reviewStream){
  return ExpandablePanel(
    header: const Padding(
        padding: EdgeInsets.all(10.0),
      child: Text(
          'Reviews',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
      collapsed: const SizedBox(height: 5,),
      expanded: reviewsAll(reviewStream),
  );
}

Widget reviewsAll(var reviewStream){
  return StreamBuilder<QuerySnapshot>(
    stream: reviewStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2){
      if(snapshot2.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(snapshot2.data!.docs.isEmpty){
        return const Center(
          child: Text(
            'This collectible \n has no reviews yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        );
      }
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    snapshot2.data!.docs[index]['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        snapshot2.data!.docs[index]['rate'].toString(),
                      ),
                      const Icon(
                          Icons.star,color: Colors.amber,
                      ),
                    ],
                  )
                ],
              ),
              subtitle: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      snapshot2.data!.docs[index]['headline'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                    ),
                  ),
                  Text(
                      snapshot2.data!.docs[index]['review']
                  ),
                ],
              ),
            );
          }
      );
    },
  );
}

