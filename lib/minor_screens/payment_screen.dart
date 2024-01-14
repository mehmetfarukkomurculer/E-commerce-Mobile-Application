import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String orderId;
  late String userEmail;
  late String emailBody;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');
  void showProgress(){
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'Placing your order...', progressBgColor: Colors.orange);
  }
  emailSendToUser(String emailBody, String userEmail)async{
    String username = 'cs308team16@hotmail.com';
    String password = 'cs308.147258';
    final smtpServer = hotmail(username, password);
    final message = Message()
      ..from = Address(username, 'CS308 Team')
      ..recipients.add(userEmail)
      ..subject = 'Order Confirmation'
      ..text = emailBody;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int cardNumber;
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
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.grey.shade400,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.brown,
                    title: const Text(
                      'Payment',
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
                  body: SafeArea(
                    child: Padding(
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Price',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        totalPrice.toStringAsFixed(2) + " USD",
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Order',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        totalPrice.toStringAsFixed(2) + " USD",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Shipping Cost',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "0.00 USD",
                                        style: TextStyle(
                                            fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              'Enter credit cart information',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        ]
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          child: TextFormField(
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'Please enter your card number!';
                                              }else if(value.isValidCardNumber() != true) {
                                                return 'Not valid card number';
                                              }
                                              return null;
                                            },
                                            onSaved: (value){
                                              cardNumber = int.parse(value!);
                                            },
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            decoration: textFormDecoration.copyWith(
                                              labelText: 'Credit Card Number',
                                              hintText: '16 digits',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: TextFormField(
                                                validator: (value){
                                                  if(value!.isEmpty){
                                                    return 'Enter expiration date';
                                                  }else if(value.isValidExpDate() != true) {
                                                    return 'Not valid expiration date!';
                                                  }
                                                  return null;
                                                },
                                                decoration: textFormDecoration.copyWith(
                                                  labelText: 'Expiration Date',
                                                  hintText: '../..',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: TextFormField(
                                                validator: (value){
                                                  if(value!.isEmpty){
                                                    return 'Enter CVC!';
                                                  }else if(value.isValidCVC() != true) {
                                                    return 'Not valid CVC';
                                                  }
                                                  return null;
                                                },
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                decoration: textFormDecoration.copyWith(
                                                  labelText: 'CVC',
                                                  hintText: 'CVC',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/credit.png', height: 200,),
                                        ],
                                      ),
                                    ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              onPressed: () async {
                                if(_formKey.currentState!.validate()) {
                                  double totall = 0.0;
                                  double totall2 = 0.0;
                                  showProgress();
                                  for (var item in context
                                      .read<Cart>()
                                      .getItems) {
                                    CollectionReference orderRef = FirebaseFirestore
                                        .instance.collection('orders');
                                    orderId = const Uuid().v4();
                                    await orderRef.doc(orderId).set({

                                      'cid': data['cid'],
                                      // customer id
                                      'custname': data['name'],
                                      // customer name
                                      'email': data['email'],
                                      // customer email
                                      'address': data['address'],
                                      // customer address
                                      'taxID': data['number'],
                                      // customer taxID
                                      'wallet': data['wallet'],
                                      'proid': item.documentID,
                                      'category': item.category,
                                      //product ID
                                      'proname': item.name,
                                      'orderid': orderId,
                                      // orderID
                                      'image': item.imagesUrl.first,
                                      //product image
                                      'item': item.qty,
                                      // amount
                                      'sellPrice': double.parse(item.price.toString()),
                                      // sell price
                                      'orderprice': double.parse(item.price.toString()) * item.qty,
                                      // total price for the products.

                                      'deliverystatus': 'preparing',
                                      'deliverydate': '',
                                      'orderdate': DateTime.now(),
                                      'paymentstatus': 'Credit Card',
                                      'orderreview': false,
                                      'refundrequest':false,
                                      'approvalRR': false,
                                      'approvedOrDisapproved': ''
                                    }).whenComplete(() async {
                                      await FirebaseFirestore.instance
                                          .runTransaction((transaction) async {
                                        DocumentReference documentReference = FirebaseFirestore
                                            .instance.collection('products')
                                            .doc(item.documentID);
                                        DocumentSnapshot snapshot2 = await transaction
                                            .get(documentReference);
                                        transaction.update(documentReference, {
                                          'stock': (int.parse(
                                              snapshot2['stock']) - item.qty)
                                              .toString()
                                          });
                                        });
                                      });
                                    }
                                  userEmail = data['email'];
                                  emailBody = 'Hey ' + data['name'] +',\n\nWe have received your order with ID: '+ orderId +' \nIt will be delivered as soon as possible. \nYou can trace the status of your order from Profile/Orders. \n\nYou can see the details of your order below\n\n\n';
                                  for (var item in context.read<Cart>().getItems) {
                                    totall = double.parse(item.price.toString())*item.qty;
                                    String strTotal = totall.toStringAsFixed(2);
                                    emailBody = emailBody + ('Description: ${item.name}\nQuantity: ${item.qty}\nUnitPrice: ${item.price}\nTotal: $strTotal\n\n');
                                    totall2 = totall2 + totall;
                                  }
                                  emailBody = emailBody + '\nTotal: ${totall2.toStringAsFixed(2)} \n\n\nRegards, CS308 TEAM';
                                  emailSendToUser(emailBody, userEmail);
                                  context.read<Cart>().clearCart();
                                  Navigator.popUntil(context, ModalRoute.withName('/customer_home'));
                                  }
                                },
                              child: Text(
                                'CONFIRM ${totalPrice.toStringAsFixed(2)} USD',
                                style: const TextStyle(
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
var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(color: Colors.black),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.black, width: 1),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.lightBlue, width: 3),
    borderRadius: BorderRadius.circular(10),
  ),
);


extension CardNumberValidator on String{
  bool isValidCardNumber (){
    return RegExp(r'^[0-9]{16,16}$').hasMatch(this);
  }
}

extension ExpDateValidator on String{
  bool isValidExpDate (){
    return RegExp(r'^((([0][1-9])||([1][0-2]))[/][2][3-9])$').hasMatch(this);
  }
}

extension CVCValidator on String{
  bool isValidCVC (){
    return RegExp(r'^[0-9]{3,3}$').hasMatch(this);
  }
}
