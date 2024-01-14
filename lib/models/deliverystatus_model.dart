import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DeliveryStatusModel extends StatelessWidget {
  final dynamic order;
  const DeliveryStatusModel({Key? key, required this.order}) : super(key: key);

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
                    child: Image.network(order['image']),
                  ),
                ),
                Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['proname'],
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
                              Text(('\$ ') + (order['orderprice'].toStringAsFixed(2))),
                              Text(('x ')+(order['item'].toString())),
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
              Text(order['deliverystatus']),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name : ' + order['custname'], style: const TextStyle(fontSize: 15),),
                    Text('Delivery Address : ' + order['address'], style: const TextStyle(fontSize: 15),maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('Tax ID : ' + order['taxID'], style: const TextStyle(fontSize: 15),),
                    Text('E-mail : ' + order['email'], style: const TextStyle(fontSize: 15),),
                    Row(
                        children: [
                          const Text('Payment Status: ', style: TextStyle(
                            fontSize: 15,
                          ),
                          ),
                          Text(
                            order['paymentstatus'],
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
                            order['deliverystatus'],
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
                            (DateFormat('yyyy-MM-dd').format(order['orderdate'].toDate()).toString()),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          ),
                        ]
                    ),
                    order['deliverystatus'] == 'delivered'
                        ? const Text('Order is delivered', style: TextStyle(color: Colors.red, fontSize: 15),)
                        :Row(
                        children: [
                          const Text('Change Delivery Status To: ', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          order['deliverystatus'] == 'preparing' ? TextButton(
                            onPressed: (){
                              DatePicker.showDatePicker(context,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime.now().add(const Duration(days: 30)),
                                onConfirm: (date) async {
                                  await FirebaseFirestore.instance.collection('orders').doc(order['orderid']).update({
                                    'deliverystatus':'shipping',
                                    'deliverydate':date,
                                  });
                                }
                              );
                            },
                            child: const Text(
                              'shipping ?',
                            ),
                          )
                              :TextButton(
                            onPressed: ()async {
                              await FirebaseFirestore.instance.collection('orders').doc(order['orderid']).update({
                                'deliverystatus':'delivered',
                              });
                            },
                            child: const Text(
                              'delivered ?',
                            ),
                          )
                        ]
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