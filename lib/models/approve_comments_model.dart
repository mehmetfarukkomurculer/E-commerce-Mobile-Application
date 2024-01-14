import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/widgets/alertdialog.dart';

class ApproveCommentsModel extends StatefulWidget {
  final dynamic comments;
  const ApproveCommentsModel({Key? key, required this.comments}) : super(key: key);

  @override
  State<ApproveCommentsModel> createState() => _ApproveCommentsModelState();
}

class _ApproveCommentsModelState extends State<ApproveCommentsModel> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Comment is sent for the product: \n' + widget.comments['product'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                      widget.comments['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.comments['headline'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.comments['rate'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Icon(Icons.star, color: Colors.yellow,),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 7,),
                  Text(
                    widget.comments['review'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            MyAlertDialog.showMyDialog(
                              context: context,
                              title: 'Approve Comment',
                              content: 'Are you sure to approve this comment?',
                              tabno: (){
                                Navigator.pop(context);
                              },
                              tabyes: ()async{
                                Navigator.pop(context);
                                await FirebaseFirestore.instance.collection('reviews').doc('review-'+widget.comments['email']+'-'+widget.comments['product']).update({
                                  'approved': true,
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
                              title: 'Disapprove Comment',
                              content: 'Are you sure to disapprove this comment?',
                              tabno: (){
                                Navigator.pop(context);
                              },
                              tabyes: ()async{
                                Navigator.pop(context);
                                await FirebaseFirestore.instance.collection('reviews').doc('review-'+widget.comments['email']+'-'+widget.comments['product']).delete();
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