import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/minor_screens/product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late double minValue = 0.0;
  late double maxValue = 10.0;
  late final Stream<QuerySnapshot> streamPriceRange = FirebaseFirestore.instance
      .collection('products')
      .where(double.parse('sellPrice'), isLessThan: maxValue ).where(double.parse('sellPrice'), isGreaterThan: minValue)
      .snapshots();

  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: CupertinoSearchTextField(
          autofocus: true,
          backgroundColor: Colors.white,
          onChanged: (value){
            setState((){
              searchInput = value;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final result = snapshot.data!.docs.where(
                    (e) => e['name']
                    .contains(searchInput) || e['des']
                    .contains(searchInput),
              );
              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView(
                        children: result.map((e) => SearchModel(e: e)).toList(),
                      ),
                    ),
                  ),
                ]
              );
            },
          ),
    );
  }
}
extension QuantityValidator on String{
  bool isValidQuantity (){
    return RegExp(r'^[0-9]*$').hasMatch(this);
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> ProductDetailsScreen(productList: e)));
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                      image: NetworkImage(e['images'][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          e['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          e['des'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          e['sellPrice'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
