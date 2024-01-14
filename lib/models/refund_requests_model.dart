import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/widgets/alertdialog.dart';

class RefundRequestsModel extends StatefulWidget {
  final dynamic requests;
  const RefundRequestsModel({Key? key, required this.requests}) : super(key: key);

  @override
  State<RefundRequestsModel> createState() => _RefundRequestsModelState();
}

class _RefundRequestsModelState extends State<RefundRequestsModel> {

  late int stock = 0;
  fetchDoc() async {
    // enter here the path , from where you want to fetch the doc
    DocumentSnapshot pathData = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.requests['productID'])
        .get();

    if (pathData.exists) {
      Map<String, dynamic>? fetchDoc = pathData.data() as Map<String, dynamic>?;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.requests['productID']).update({
        'stock': (int.parse(fetchDoc?['stock']) + widget.requests['refundStock']).toString(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Refund request is sent for the product:',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  const DetailHeaderLabel(label: '  Product Details  '),
                  SizedBox(
                    height: 130,
                    child: Row(
                      children: [
                        Image.network(widget.requests['productImage']),
                        const SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.requests['productName'], maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(double.parse(widget.requests['orderPrice']).toStringAsFixed(2) + ' USD'),
                                  Text('x ' + widget.requests['refundStock'].toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const DetailHeaderLabel(label: '  Customer Details  '),
                  Column(
                    children: [
                      Text('ID: ' + widget.requests['customerID']),
                      Text('Name: ' + widget.requests['name']),
                      Text('E-mail: ' + widget.requests['email']),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const DetailHeaderLabel(label: '  Request Details  '),
                  Column(
                    children: [
                      Text('Order ID: ' + widget.requests['orderID']),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          const Text('REASON:    ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                          Text(widget.requests['reason'], style: const TextStyle(
                            fontSize: 16
                          ),),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  widget.requests['approvalRefundRequest'] == false ? SizedBox(
                      height: 35,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              MyAlertDialog.showMyDialog(
                                context: context,
                                title: 'Approve Refund Request',
                                content: 'Are you sure to approve this refund request?',
                                tabno: (){
                                  Navigator.pop(context);
                                },
                                tabyes: ()async{
                                  Navigator.pop(context);
                                  await FirebaseFirestore.instance.collection('users').doc(widget.requests['customerID']).update({
                                    'wallet': FieldValue.increment(double.parse(widget.requests['orderPrice']))// + widget.requests['custWallet'],
                                  }).whenComplete(() => {
                                    FirebaseFirestore.instance.collection('refundRequests').doc(widget.requests['orderID']).update({
                                    'approvalRefundRequest': true,
                                      'approvedOrDisapproved': 'approved',
                                    }).whenComplete(() => {
                                      FirebaseFirestore.instance.collection('orders').doc(widget.requests['orderID']).update({
                                        'approvalRR': true,
                                        'approvedOrDisapproved': 'approved',
                                      }).whenComplete(() => {
                                        fetchDoc(),
                                      }).whenComplete(() => {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Refund Request is Accepted'),
                                            content: const Text('Customer is going to be informed'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Go Back'),
                                              )
                                            ],
                                          ),
                                        )
                                      })
                                    }),
                                  });
                                },
                              );

                            },
                            child: const Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              MyAlertDialog.showMyDialog(
                                context: context,
                                title: 'Disapprove Refund Request',
                                content: 'Are you sure to disapprove this refund request?',
                                tabno: (){
                                  Navigator.pop(context);
                                },
                                tabyes: ()async{
                                  Navigator.pop(context);
                                  await FirebaseFirestore.instance.collection('refundRequests').doc(widget.requests['orderID']).update({
                                    'approvedOrDisapproved': 'disapproved',
                                    'approvalRefundRequest': true,
                                  }).whenComplete(() => {
                                      FirebaseFirestore.instance.collection('orders').doc(widget.requests['orderID']).update({
                                      'approvalRR': false,
                                        'approvedOrDisapproved': 'disapproved',
                                  }).whenComplete(() => {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                        title: const Text('Refund Request is Rejected'),
                                        content: const Text('Customer is going to be informed'),
                                        actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                          Navigator.pop(context);
                                          },
                                          child: const Text('Go Back'),
                                          )
                                        ],
                                      ),
                                    )
                                  })
                                });
                              },
                            );
                          },
                            child: const Text('Disapprove'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ],
                      )
                  ) : widget.requests['approvedOrDisapproved'] == 'approved'
                      ? const Text('This refund request is approved!', style: TextStyle(color: Colors.green),)
                      : widget.requests['approvedOrDisapproved'] == 'disapproved' ? const Text('This refund request is disapproved!', style: TextStyle(color: Colors.red)) : const Text('')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailHeaderLabel extends StatelessWidget {
  final String label;
  const DetailHeaderLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
            width: 80,
            child: Divider(
              color: Colors.deepOrange,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
            width: 80,
            child: Divider(
              color: Colors.deepOrange,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}