import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetDiscountModel extends StatefulWidget {
  final dynamic products;
  const SetDiscountModel({Key? key, required this.products}) : super(key: key);

  @override
  State<SetDiscountModel> createState() => _SetDiscountModelState();
}

class _SetDiscountModelState extends State<SetDiscountModel> {
  late TextEditingController controller;
  String edited_discount = '';
  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  Future<String?> openDialog() => showDialog<String>(
    context: context,
    builder: (context)=> AlertDialog(
      title: const Text('Set Discount'),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter a value'),
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: update,
          child: const Text('Set Discount'),
        ),
      ],
    ),
  );
  void update(){
    Navigator.of(context).pop(controller.text);
  }
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
                  const SizedBox(height: 7,),
                  Text('Discount: ' + widget.products['discount'] +'%', style: const TextStyle(
                    fontSize: 18,fontWeight: FontWeight.bold, color: Colors.red,
                  ),),
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
                      onPressed: ()async{
                          final editedDiscount = await openDialog();
                          if(editedDiscount == null ||  editedDiscount.isEmpty) return;
                          setState(() => this.edited_discount = editedDiscount);
                          await FirebaseFirestore.instance.collection('products').doc(widget.products['id']).update({
                                'discount':editedDiscount,
                                'sellPrice':(double.parse(widget.products['actualPrice']) -(double.parse(widget.products['actualPrice']) * double.parse(edited_discount) / 100)).toString(),
                            });
                          Get.snackbar('Hi', 'i am a modern snackbar');
                        },
                      child: const Text('Set Discount'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen,
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