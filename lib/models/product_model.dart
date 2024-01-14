import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/minor_screens/product_details.dart';
import 'package:untitled3/providers/wishlist_provider.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> ProductDetailsScreen(productList: widget.products,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children:[
            Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children:[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 100, maxHeight: 250),
                    child: Image(
                      image: NetworkImage(widget.products['images'][0]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.products['name'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 7,),
                      Text('Stock: ' + widget.products['stock'].toString()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (double.parse(widget.products['sellPrice'].toString())).toStringAsFixed(2) + ('\$'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          int.parse(widget.products['discount']) != 0
                              ? Text((double.parse(widget.products['actualPrice'].toString())).toStringAsFixed(2)  + ('\$'),
                            style: const TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                              : Container(color: Colors.transparent),
                          widget.products['email'] == FirebaseAuth.instance.currentUser!.email
                          ? IconButton(
                              onPressed: (){},
                              icon: const Icon(
                                  Icons.edit,
                                color: Colors.red,
                              ),
                          )
                          : IconButton(
                            onPressed: (){
                              var existingItemWishlist = context
                                  .read<Wishlist>()
                                  .getWishlistItems
                                  .firstWhereOrNull(
                                      (productDeclare) => productDeclare.documentID == widget.products['id']);
                              existingItemWishlist != null
                                  ? context.read<Wishlist>().removeThis(widget.products['id'])
                                  : context.read<Wishlist>().addWishlistItem(
                                widget.products['name'].toString(),
                                double.parse(widget.products['sellPrice'].toString()),
                                1,
                                int.parse(widget.products['stock'].toString()),
                                widget.products['images'],
                                widget.products['id'].toString(),
                                widget.products['email'].toString(),
                                widget.products['category'].toString(),
                              );
                            },
                            icon: context.watch<Wishlist>().getWishlistItems.firstWhereOrNull((productDeclare) =>
                            productDeclare.documentID == widget.products['id']) != null
                                ? const Icon(
                                Icons.favorite,
                                color: Colors.red)
                                : const Icon(
                              Icons.favorite_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
            int.parse(widget.products['discount']) != 0 ? Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: 35,
                width: 105,
                decoration: const BoxDecoration(
                  color: Colors.yellowAccent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                ),
                child: Center(
                  child: int.parse(widget.products['stock']) != 0 ?Text(
                    'Save ${widget.products['discount']} %',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ) : const Text('OUT OF STOCK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ),
            ) : Container(
              color: Colors.transparent,
            ),
        ],
        ),
      ),
    );
  }
}