import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/minor_screens/place_order.dart';
import 'package:untitled3/models/cart_model.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:untitled3/screens/customer_home.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/widgets/alertdialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text(
          'Cart', style: TextStyle(
          color: Colors.white,
        ),
        ),
        actions: [
          context.watch<Cart>().getItems.isEmpty ? const SizedBox():
          IconButton(
              onPressed: (){
                MyAlertDialog.showMyDialog(
                    context: context,
                    title: 'Clear All Items',
                    content: 'Are you sure to clear cart?',
                    tabno: (){
                      Navigator.pop(context);
                    },
                    tabyes: (){
                      context.read<Cart>().clearCart();
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
        context.watch<Cart>().getItems.isNotEmpty
          ? const CartItems()
          : const EmptyCart(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                 const Text('Total: \$ ',
                  style: TextStyle(fontSize: 18,),
                ),
                 Text(
                   total.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.brown, borderRadius: BorderRadius.circular(25),
              ),
              child: MaterialButton(
                  onPressed: total == 0.0
                      ? null
                      :(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceOrderScreen()));
                  },
                child: const Text('CHECK OUT', style: TextStyle(
                  color: Colors.white,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Your cart is empty!', style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 50),
          Material(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CustomerHomeScreen()));
              },
              child: const Text(
                'Continue shopping',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class CartItems extends StatelessWidget {
  const CartItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context, cart, child){
          return ListView.builder(
              itemCount: cart.count,
              itemBuilder: (context, index){
                final productDeclare = cart.getItems[index];
                return CartModel(productDeclare: productDeclare, cart: context.read<Cart>());
              });
        });
  }
}





