import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled3/pdf/customerPdf.dart';
import 'package:untitled3/pdf/invoice.dart';
import 'package:untitled3/pdf/pdf_api.dart';
import 'package:untitled3/pdf/pdf_invoice_api.dart';
import 'package:untitled3/pdf/supplierPdf.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({Key? key, required this.order}) : super(key: key);

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  late String comment;
  late String headline;
  late String reviewDocName;
  late String reason = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(
              maxHeight: 80,
            ),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                      maxWidth: 80,
                    ),
                    child: Image.network(widget.order['image']),
                  ),
                ),
                Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order['proname'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(('\$ ') + (widget.order['orderprice'].toStringAsFixed(2))),
                              Text(('x ')+(widget.order['item'].toString())),
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Details'),
              Text(widget.order['deliverystatus']),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliverystatus'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name : ' + widget.order['custname'], style: const TextStyle(fontSize: 15),),
                    Text('Delivery Address : ' + widget.order['address'], style: const TextStyle(fontSize: 15),maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('Tax ID : ' + widget.order['taxID'], style: const TextStyle(fontSize: 15),),
                    Text('E-mail : ' + widget.order['email'], style: const TextStyle(fontSize: 15),),
                    Row(
                        children: [
                          const Text('Payment Status: ', style: TextStyle(
                            fontSize: 15,
                          ),
                          ),
                          Text(
                            widget.order['paymentstatus'],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.purple,
                            ),
                          )
                        ]
                    ),
                    Row(
                        children: [
                          const Text('Delivery Status: ', style: TextStyle(
                            fontSize: 15,
                          ),
                          ),
                          Text(
                            widget.order['deliverystatus'],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          )
                        ]
                    ),
                    Row(
                        children: [
                          const Text('Order Date: ', style: TextStyle(
                            fontSize: 15,
                          ),
                          ),
                          Text(
                            (DateFormat('yyyy-MM-dd').format(widget.order['orderdate'].toDate()).toString()),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          ),
                        ]
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                        'Estimated Delivery Date : ' + (DateFormat('yyyy-MM-dd').format(widget.order['deliverydate'].toDate())).toString(),
                        style: const TextStyle(fontSize: 15))
                        : const Text(''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false && widget.order['refundrequest'] == false
                            ? ElevatedButton(
                          onPressed: (){

                            showDialog(
                                context: context,
                                builder: (context) => Material(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 100),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        RatingBar.builder(
                                          initialRating : 1,
                                            minRating: 1,
                                            allowHalfRating: true,
                                            itemBuilder: (context, _){
                                              return const Icon(
                                                Icons.star, color: Colors.amber,
                                              );
                                            },
                                            onRatingUpdate: (value){
                                              rate = value;
                                            }
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Write a headline',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.brown,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          onChanged: (value){
                                            headline = value;
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Write a comment',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.brown,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          onChanged: (value){
                                            comment = value;
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.brown,
                                              ),
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.brown,
                                              ),
                                              onPressed: () async {
                                                CollectionReference collRef = FirebaseFirestore.instance.collection('reviews');
                                                reviewDocName = 'review-' + widget.order['email'] + '-'+widget.order['proid'];
                                                await collRef.doc(reviewDocName).set({
                                                  'name': widget.order['custname'],
                                                  'email':widget.order['email'],
                                                  'product': widget.order['proid'],
                                                  'rate': rate,
                                                  'review': comment,
                                                  'headline': headline,
                                                  'approved': false
                                                }).whenComplete(() async {
                                                  await FirebaseFirestore.instance.runTransaction((transaction) async{
                                                    DocumentReference documentReference = FirebaseFirestore.instance.collection('orders').doc(widget.order['orderid']);
                                                    await transaction.update(documentReference, {
                                                      'orderreview' : true,
                                                    });
                                                  });
                                                });
                                                await Future.delayed(const Duration(microseconds: 100)).whenComplete(() =>
                                                  Navigator.pop(context),
                                                );
                                                },
                                              child: const Text('Send'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          },
                          child: const Text('Write a comment'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                        )
                            : const Text(''),

                        widget.order['deliverystatus'] == 'delivered' && widget.order['refundrequest'] == false && DateTime.now().isBefore((widget.order['orderdate'].toDate()).add(const Duration(days: 15)))
                            ? ElevatedButton(
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>  Material(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text('Details of the order you want to refund is below.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Divider(
                                            thickness: 2,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 130,
                                            child: Row(
                                              children: [
                                                Image.network(widget.order['image']),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(widget.order['proname'],
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),

                                                        ),
                                                        Text('x '+widget.order['item'].toString(),
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),),
                                                        Text(
                                                            'Total money that will be refunded\n' + widget.order['orderprice'].toStringAsFixed(2) + ' USD',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.redAccent,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Divider(
                                            thickness: 2,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              const Icon(Icons.warning, color: Colors.red, size: 50),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'Order Date: ' + DateFormat('yyyy-MM-dd').format(widget.order['orderdate'].toDate()).toString(),
                                                  ),
                                                  Text(
                                                      'Last date to send a refund request: \n' + DateFormat('yyyy-MM-dd').format(widget.order['orderdate'].toDate().add(const Duration(days: 30))).toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Divider(
                                            thickness: 2,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text('Please write the reason of refund request'.toUpperCase(), textAlign: TextAlign.center ,style: const TextStyle(
                                            color: Colors.deepOrange,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Reason',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.blueAccent,
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            onChanged: (value){
                                              reason = value;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                ),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blueAccent,
                                                ),
                                                onPressed: () async {
                                                  if(reason != '') {
                                                    CollectionReference collRef = FirebaseFirestore
                                                        .instance.collection(
                                                        'refundRequests');
                                                    await collRef.doc(
                                                        widget.order['orderid'])
                                                        .set({
                                                      'name': widget
                                                          .order['custname'],
                                                      'email': widget
                                                          .order['email'],
                                                      'customerID': widget
                                                          .order['cid'],
                                                      'productID': widget
                                                          .order['proid'],
                                                      'productName': widget
                                                          .order['proname'],
                                                      'custWallet': widget
                                                          .order['wallet'],
                                                      'refundStock': widget
                                                          .order['item'],
                                                      'orderID': widget
                                                          .order['orderid'],
                                                      'orderPrice': widget
                                                          .order['orderprice']
                                                          .toStringAsFixed(2),
                                                      'productImage': widget
                                                          .order['image'],
                                                      'approvalRefundRequest': false,
                                                      'reason': reason,
                                                      'approvedOrDisapproved': 'pending',
                                                    })
                                                        .whenComplete(() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction((
                                                          transaction) async {
                                                        DocumentReference documentReference = FirebaseFirestore
                                                            .instance.collection(
                                                            'orders').doc(widget
                                                            .order['orderid']);
                                                        await transaction.update(
                                                            documentReference, {
                                                          'refundrequest': true,
                                                        });
                                                      });
                                                    });
                                                    await Future.delayed(
                                                        const Duration(
                                                            microseconds: 100))
                                                        .whenComplete(() =>
                                                        Navigator.pop(context),
                                                    );
                                                  }else{
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('We need one more thing'),
                                                        content: const Text('Please write a reason'),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text('Go Back'),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Text('Send'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              );

                            },
                            child: const Text('Refund Request'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                        )
                            : widget.order['refundrequest'] == false && widget.order['deliverystatus'] == 'delivered' ? const Text('15 days passed', style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        ) : const Text(''),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'delivered' &&
                        widget.order['orderreview'] == true ? Row(
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.blue,
                        ),
                        Text(
                          'Comment is sent',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ) : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' && widget.order['refundrequest'] == true
                        ? Row(
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.red,
                        ),
                        Text(
                          'Refund request is sent',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ) : const Text(''),
                    widget.order['approvalRR'] == true
                        && widget.order['deliverystatus'] == 'delivered'
                        && widget.order['refundrequest'] == true
                        && widget.order['approvedOrDisapproved'] == 'approved'
                        ? Row(
                      children: [
                        const Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                        ),
                        Text(
                          'Refund request is approved: \n' + widget.order['orderprice'].toStringAsFixed(2) + ' USD is refunded to your wallet!',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ) : widget.order['approvalRR'] == false
                        && widget.order['deliverystatus'] == 'delivered'
                        && widget.order['refundrequest'] == true
                        && widget.order['approvedOrDisapproved'] == 'disapproved'
                        ? Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.red,
                        ),
                        Text(
                          'Refund request is disapproved',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ) : const Text(''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final date = DateTime.now();
                            final dueDate = date.add(
                              const Duration(days: 30),
                            );
                            final invoice = Invoice(
                              supplierPDF: const SupplierPDF(
                                name: 'Collectible Store',
                                address: 'Sabanci University, Tuzla/Istanbul/Turkey',
                                paymentInfo: 'Paid with Credit Card',
                              ),
                              customerPDF: CustomerPDF(
                                name: widget.order['custname'],
                                address: widget.order['address'],
                                taxID: widget.order['taxID'],
                                email: widget.order['email'],
                                cid: widget.order['cid'],
                              ),
                              info: InvoiceInfo(
                                date: date,
                                dueDate: dueDate,
                                description: "You can see the details of your order below.",
                                number: widget.order['orderid'],
                              ),
                              items: [
                                InvoiceItem(
                                  description: widget.order['proname'],
                                  quantity: widget.order['item'],
                                  unitPrice: widget.order['sellPrice'],
                                  total: widget.order['item'] * widget.order['sellPrice'],
                                ),
                              ],
                            );
                            final pdfFile = await PdfInvoiceApi
                                .generate(invoice);
                            PdfApi.openFile(pdfFile);
                          },
                          child: const Text(
                            'View Invoice',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}