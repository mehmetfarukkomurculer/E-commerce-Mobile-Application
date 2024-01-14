import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:untitled3/providers/product_class.dart';
import 'package:untitled3/providers/wishlist_provider.dart';


class CartModel extends StatelessWidget {
  const CartModel({Key? key, required this.productDeclare, required this.cart}) : super(key: key);
  final Product productDeclare;
  final Cart cart;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: Image.network(
                  productDeclare.imagesUrl.first,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productDeclare.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      productDeclare.qntty < 20 ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Remaining Stock: " + productDeclare.qntty.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                            "!!!! This product is about to run out",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          )
                        ],
                      )
                          : Text(
                        "Stock: " + productDeclare.qntty.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productDeclare.price.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                productDeclare.qty == 1 ? IconButton(
                                    onPressed: (){
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoActionSheet(
                                          title: const Text('Remove Collectible'),
                                          message: const Text('Are you sure to remove this collectible?'),
                                          actions: <CupertinoActionSheetAction>[
                                            CupertinoActionSheetAction(
                                              child: const Text('Move to Wishlist'),
                                              onPressed: () async {
                                                context.read<Wishlist>().getWishlistItems.firstWhereOrNull((element) =>
                                                element.documentID == productDeclare.documentID) != null
                                                    ? context.read<Cart>().removeItem(productDeclare)
                                                    : await context.read<Wishlist>().addWishlistItem(
                                                  productDeclare.name.toString(),
                                                  double.parse(productDeclare.price.toString()),
                                                  1,
                                                  int.parse(productDeclare.qntty.toString()),
                                                  productDeclare.imagesUrl,
                                                  productDeclare.documentID.toString(),
                                                  productDeclare.supplierID.toString(),
                                                  productDeclare.category.toString(),
                                                );
                                                context.read<Cart>().removeItem(productDeclare);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CupertinoActionSheetAction(
                                              child: const Text('Remove'),
                                              onPressed: (){
                                                context.read<Cart>().removeItem(productDeclare);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                          cancelButton: TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                              ),),
                                          ),
                                        ),
                                      );
                                      /*MyAlertDialog.showMyDialog(
                                                    context: context,
                                                    title: 'Remove item',
                                                    content: 'Are you sure to remove this item?',
                                                    tabno: (){
                                                      Navigator.pop(context);
                                                    },
                                                    tabyes: (){
                                                      cart.removeItem(productDeclare);
                                                      Navigator.pop(context);
                                                    },
                                                  );*/
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 18,
                                      color: Colors.white,
                                    ))
                                    :  IconButton(
                                  onPressed: (){
                                    cart.decrement(productDeclare);
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  productDeclare.qty.toString(),
                                  style: productDeclare.qty == productDeclare.qntty ? const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red)
                                      : const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                IconButton(
                                    onPressed: productDeclare.qty == productDeclare.qntty ? null
                                        : (){
                                      cart.increment(productDeclare);
                                    },
                                    icon: productDeclare.qty == productDeclare.qntty ? const Icon(
                                      Icons.add,
                                      size: 15,
                                      color: Colors.brown,
                                    ) : const Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.white,
                                    )
                                ),
                              ],
                            ) ,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}