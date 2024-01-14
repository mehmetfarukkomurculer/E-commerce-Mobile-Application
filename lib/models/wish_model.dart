import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/product_class.dart';
import 'package:untitled3/providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import 'package:collection/collection.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({Key? key, required this.productDeclare}) : super(key: key);

  final Product productDeclare;

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
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                context.read<Wishlist>().removeItem(productDeclare);
                              },
                                  icon: const Icon(Icons.delete_forever)),
                              const SizedBox(
                                width: 10,
                              ),
                              context.watch<Cart>().getItems.firstWhereOrNull((element) =>
                              element.documentID == productDeclare.documentID) != null || productDeclare.qntty == 0
                                  ? const SizedBox()
                                  :IconButton(
                                  onPressed: (){
                                    context.read<Cart>().addItem(
                                      productDeclare.name.toString(),
                                      double.parse(productDeclare.price.toString()),
                                      1,
                                      int.parse(productDeclare.qntty.toString()),
                                      productDeclare.imagesUrl,
                                      productDeclare.documentID.toString(),
                                      productDeclare.supplierID.toString(),
                                      productDeclare.category.toString(),
                                    );
                                  },
                                  icon: const Icon(Icons.add_shopping_cart)),
                            ],
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