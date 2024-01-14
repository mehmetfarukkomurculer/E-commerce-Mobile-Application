import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/models/wish_model.dart';
import 'package:untitled3/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/widgets/alertdialog.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text(
          'Wishlist', style: TextStyle(
          color: Colors.white,
        ),
        ),
        actions: [
          context.watch<Wishlist>().getWishlistItems.isEmpty ? const SizedBox():
          IconButton(
            onPressed: (){
              MyAlertDialog.showMyDialog(
                context: context,
                title: 'Clear All Items',
                content: 'Are you sure to clear wishlist?',
                tabno: (){
                  Navigator.pop(context);
                },
                tabyes: (){
                  context.read<Wishlist>().clearWishlist();
                  Navigator.pop(context);
                },
              );
            },
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body:
      context.watch<Wishlist>().getWishlistItems.isNotEmpty
          ? const WishlistItems()
          : const EmptyWishlist(),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Your wishlist is empty!',
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}



class WishlistItems extends StatelessWidget {
  const WishlistItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wishlist>(
        builder: (context, wishlist, child){
          return ListView.builder(
              itemCount: wishlist.count,
              itemBuilder: (context, index){
                final productDeclare = wishlist.getWishlistItems[index];
                return WishlistModel(productDeclare: productDeclare);
              });
        });
  }
}




