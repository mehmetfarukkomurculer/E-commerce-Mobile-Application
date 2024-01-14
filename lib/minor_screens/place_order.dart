import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/minor_screens/payment_screen.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:untitled3/screens/profile.dart';
import 'package:untitled3/widgets/alertdialog.dart';
import 'package:untitled3/widgets/snackbar.dart';


class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');
  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseAuth.instance.currentUser!.isAnonymous
        ? anonymous.doc(FirebaseAuth.instance.currentUser!.uid).get()
        :users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
    builder:
    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if(snapshot.hasData && !snapshot.data!.exists){
          return const Text('Document does not exist');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Material(
            color: Colors.brown,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade400,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.brown,
                  title: const Text(
                    'Place Order',
                  ),
                  actions: [
                    IconButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/customer_home');
                      },
                      icon: const Icon(Icons.home),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Name: ${data['name']}'
                              ),
                              Text(
                                  'Tax ID: ${data['number']}'
                              ),
                              Text(
                                  'E-mail: ${data['email']}'
                              ),
                              Text(
                                  'Address: ${data['address']}'
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Consumer<Cart>(
                            builder: (context, cart, child){
                            return ListView.builder(
                                itemCount: cart.count,
                                itemBuilder: (context, index){
                                 final order = cart.getItems[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                          ),
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(order.imagesUrl.first),
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                order.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      order.price.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      'x ${order.qty.toString()}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet:Container(
                  color: Colors.grey.shade400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.brown, borderRadius: BorderRadius.circular(25),
                          ),
                          child: MaterialButton(
                            onPressed:FirebaseAuth.instance.currentUser!.isAnonymous
                                ? (){
                              MyAlertDialog.showMyDialog(
                                context: context,
                                title: 'You have to register before shopping',
                                content: 'Do you want to register?',
                                tabno: (){
                                  Navigator.pop(context);
                                },
                                tabyes: (){
                                  Navigator.pushReplacementNamed(context, '/customer_register');
                                },
                              );
                            }
                                : data['address'] == ""
                                ?  (){
                              MyAlertDialog.showMyDialog(
                                context: context,
                                title: 'You have to edit your address in your profile',
                                content: 'Do you want to edit now? Visit your profile!',
                                tabno: (){
                                  Navigator.pop(context);
                                },
                                tabyes: (){
                                  Navigator.pushReplacementNamed(context, '/customer_home');
                                },
                              );
                            }
                                :(){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PaymentScreen()));
                            },
                            child: const Text(
                              'PAY NOW',
                              style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
         ),
            ),
          );
      }return const Center(
          child: CircularProgressIndicator(),
        );
    });
  }
}
