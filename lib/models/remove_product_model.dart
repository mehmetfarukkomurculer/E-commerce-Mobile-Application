import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/widgets/alertdialog.dart';

class RemoveProductModel extends StatefulWidget {
  final dynamic products;
  const RemoveProductModel({Key? key, required this.products}) : super(key: key);

  @override
  State<RemoveProductModel> createState() => _RemoveProductModelState();
}

class _RemoveProductModelState extends State<RemoveProductModel> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children:[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 100, maxHeight: 100),
                child: Image(
                  image: NetworkImage(widget.products['images'][0]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.products['name'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 7,),
                  Text('Stock: ' + widget.products['stock'].toString()),
                  const SizedBox(height: 7,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        double.parse(widget.products['sellPrice'].toString()).toString() + (' \$'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        MyAlertDialog.showMyDialog(
                          context: context,
                          title: 'Remove Item',
                          content: 'Are you sure to remove this item?',
                          tabno: (){
                            Navigator.pop(context);
                          },
                          tabyes: ()async{
                            await FirebaseFirestore.instance.collection('products').doc(widget.products['id']).delete();
                            Navigator.pop(context);
                          },
                        );

                      },
                      child: const Text('Remove'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}