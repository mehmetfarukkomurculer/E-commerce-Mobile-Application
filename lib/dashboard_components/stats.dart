import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:untitled3/pdf/customerPdf.dart';
import 'package:untitled3/pdf/invoice.dart';
import 'package:untitled3/pdf/pdf_api.dart';
import 'package:untitled3/pdf/pdf_invoice_api.dart';
import 'package:untitled3/pdf/supplierPdf.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}
GlobalKey<FormState> _formkey = GlobalKey();

class _StatsState extends State<Stats> {
  DateTimeRange? myDateRange;
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();
  void _submitForm() {
    final FormState? form = _formkey.currentState;
    form!.save();
  }

  late DateTime startDate = DateTime.now().subtract(const Duration(days: 100));
  late DateTime endDate = DateTime.now();
  late Stream<QuerySnapshot> ordersStream = FirebaseFirestore.instance
      .collection('orders')
      .where('orderdate', isGreaterThan: startDate).where('orderdate', isLessThan: endDate)
      .snapshots();
  //final DateTime _startDate = DateTime.now().subtract(const Duration(days: 2));
  //final DateTime _endDate = DateTime.now();
  final colorList = <Color>[
    Colors.lightGreen,
    Colors.red,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders').where('orderdate', isGreaterThan: startDate).where('orderdate', isLessThan: endDate).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          num ComicBooksCount = 0;
          num boardGamesCount = 0;
          num rpgCount = 0;
          late double comicBooksProfit = 0;
          late double boardGamesProfit = 0;
          late double rpgProfit = 0;
          for(var item in snapshot.data!.docs){
            if(item['category'] == 'RPG'){
              rpgProfit+= item['orderprice'];
              rpgCount += item['item'];
            }else if(item['category'] == 'Board Games'){
              boardGamesProfit += item['orderprice'];
              boardGamesCount += item['item'];
            }else if(item['category'] == 'Comic Books'){
              comicBooksProfit += item['orderprice'];
              ComicBooksCount += item['item'];
            }
          }
          Map<String, double> dataMap = {
            "Comic Books Profit": comicBooksProfit,
            "Board Games Profit": boardGamesProfit,
            "RPG Profit": rpgProfit,
          };

          return ScaffoldMessenger(
            key: _scaffoldkey,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.blueAccent,
                title: const Text(
                  'Stats',
                ),
              ),
              body: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _formkey,
                                child: Column(
                                  children: [
                                    SafeArea(child: DateRangeField(
                                      firstDate: DateTime(2020),
                                      enabled: true,
                                      initialValue: DateTimeRange(
                                          start: startDate,
                                          end: endDate,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Date Range',
                                        prefixIcon: Icon(Icons.date_range),
                                        hintText: 'Please select a start and end date',
                                        border: OutlineInputBorder(),
                                      ),
                                onSaved: (value) {
                                  setState(() {
                                    startDate = value!.start;
                                    endDate = value!.end;
                                    myDateRange = value!;
                                  });
                                }
                                    ))
                                  ],
                                ),
                            ),
                            ElevatedButton(
                              child: const Text('Filter'),
                              onPressed: _submitForm,
                            ),
                            const SizedBox(
                              height: 20,
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            Text(
                              'Stats between \n${DateFormat('yyyy-MM-dd').format(startDate).toString()} and ${DateFormat('yyyy-MM-dd').format(endDate).toString()}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,

                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PieChart(
                              dataMap: dataMap,
                              colorList: colorList,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StaticsModels(
                              label: 'Number of Comic Books sold',
                              value: ComicBooksCount.toString(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StaticsModels(
                              label: 'Number of Board Games sold',
                              value: boardGamesCount.toString(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StaticsModels(
                              label: 'Number of RPG sold',
                              value: rpgCount.toString(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StaticsModels(
                              label: 'Total Profit',
                              value: (comicBooksProfit + boardGamesProfit + rpgProfit).toStringAsFixed(2) + '  USD',
                            ),
                            const SizedBox(
                              height: 20,
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            ExpandablePanel(
                              header: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Orders between \n${DateFormat('yyyy-MM-dd').format(startDate).toString()} and ${DateFormat('yyyy-MM-dd').format(endDate).toString()}',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              collapsed: const SizedBox(height: 5,),
                              expanded: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index){
                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 120,
                                            child: Image.network(
                                              snapshot.data!.docs[index]['image'],
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshot.data!.docs[index]['proname'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'x '+snapshot.data!.docs[index]['item'].toString(),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            ('Order Date: '+ DateFormat('yyyy-MM-dd').format(snapshot.data!.docs[index]['orderdate'].toDate()).toString()),
                                            //snapshot.data!.docs[index]['orderdate'].toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green
                                            ),
                                          ),
                                          Text(
                                            'Total: '+snapshot.data!.docs[index]['orderprice'].toStringAsFixed(2) +' USD',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Category: '+snapshot.data!.docs[index]['category'],
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                final date = snapshot.data!.docs[index]['orderdate'].toDate();
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
                                                    name: snapshot.data!.docs[index]['custname'],
                                                    address: snapshot.data!.docs[index]['address'],
                                                    taxID: snapshot.data!.docs[index]['taxID'],
                                                    email: snapshot.data!.docs[index]['email'],
                                                    cid: snapshot.data!.docs[index]['cid'],
                                                  ),
                                                  info: InvoiceInfo(
                                                    date: date,
                                                    dueDate: dueDate,
                                                    description: "You can see the details of your order below.",
                                                    number: snapshot.data!.docs[index]['orderid'],
                                                  ),
                                                  items: [
                                                    InvoiceItem(
                                                      description: snapshot.data!.docs[index]['proname'],
                                                      quantity: snapshot.data!.docs[index]['item'],
                                                      unitPrice: snapshot.data!.docs[index]['sellPrice'],
                                                      total: snapshot.data!.docs[index]['item'] * snapshot.data!.docs[index]['sellPrice'],
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
                                                primary: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 3,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )/*Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StaticsModels(
                        label: 'Number of Comic Books sold',
                        value: ComicBooksCount.toString(),
                    ),
                    StaticsModels(
                      label: 'Number of Board Games sold',
                      value: boardGamesCount.toString(),
                    ),
                    StaticsModels(
                      label: 'Number of RPG sold',
                      value: rpgCount.toString(),
                    ),
                    PieChart(
                        dataMap: dataMap,
                        colorList: colorList,
                    ),
                    StaticsModels(
                      label: 'Number of RPG sold',
                      value: rpgCount.toString(),
                    ),
                  ],
                ),
              ),*/
        ),
          );
      }
    );
  }
}
class ProductDetailHeaderLabel extends StatelessWidget {
  final String label;
  const ProductDetailHeaderLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.blueAccent,
              thickness: 1,
            ),
          ),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.blueAccent,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class StaticsModels extends StatelessWidget {
  final String label;
  final dynamic value;
  const StaticsModels({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width*0.7,
          decoration: const BoxDecoration(
            color: Colors.blueGrey, borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          ),
          child: Center(
            child: Text(label.toUpperCase(), style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,
            ),),
          ),
        ),
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width*0.7,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100, borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          ),
          child: Center(
            child: Text(value, style: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold,
            ),
            ),
          ),
        )
      ],
    );
  }
}

Widget reviews(var ordersStream){
  return ExpandablePanel(
    header: const Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        'Orders',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    collapsed: const SizedBox(height: 5,),
    expanded: reviewsAll(ordersStream),
  );
}
Widget reviewsAll(var ordersStream){
  return StreamBuilder<QuerySnapshot>(
    stream: ordersStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2){
      if(snapshot2.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(snapshot2.data!.docs.isEmpty){
        return const Center(
          child: Text(
            'This date range has no items to be sold',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        );
      }
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 100,
                    width: 120,
                    child: Image.network(
                      snapshot2.data!.docs[index]['image'],
                    ),
                  ),
                  Flexible(
                    child: Text(
                      snapshot2.data!.docs[index]['proname'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'x '+snapshot2.data!.docs[index]['item'].toString(),
                      ),
                    ],
                  )
                ],
              ),
              subtitle: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    snapshot2.data!.docs[index]['orderdate'].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                    ),
                  ),
                  Text(
                      snapshot2.data!.docs[index]['orderprice'].toStringAsFixed(2),
                  ),
                ],
              ),
            );
          }
      );
    },
  );
}