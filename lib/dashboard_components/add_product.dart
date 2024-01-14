import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


List<String> categories =[
  'Comic Books',
  'Board Games',
  'RPG',
  ' ',
];

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();

  late String actualPrice;//var
  late String discount = '';//var
  late String stock;//var
  late String name;//var
  late String des;//var
  late String email;
  late String sellPrice;
  late String shortDes;//var
  late String productId;
  bool tac = true;
  late String tags; //var
  late String sizes;
  String categValue = ' ';

  List<String> sizeList = [
    "Normal Edition",
  ];
  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? imagesFileList = [];
  List<String> imagesUrlList = [];
  List<String>? tagsList = [];

  dynamic _pickedImageError;

  void _pickProductImages() async {
    try{
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95);
      setState((){
        imagesFileList = pickedImages!;
      });
    } catch (e) {
      setState((){
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages(){
    if(imagesFileList!.isNotEmpty){
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index){
            return Image.file(File(imagesFileList![index].path));
          });
    }else{
      return const Center(
        child: Text(
          'You have not \n \n picked images yet!',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Future<void> uploadImagesOnly() async{
    if(categValue == 'Comic Books' || categValue == 'Board Games' || categValue == 'RPG'){
      if(_formKey.currentState!.validate()){
        _formKey.currentState!.save();
        if(imagesFileList!.isNotEmpty){
          setState((){
            processing = true;
          });
          tagsList = tags.split(",");
          try{
            for(var image in imagesFileList!){
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async{
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
          }catch(e) {print(e);}
        }else{
          MyMessageHandler.showSnackBar(_scaffoldkey, 'Please pick images!');
        }
      }else{
        MyMessageHandler.showSnackBar(_scaffoldkey, 'Please fill all fields!');
      }
    }else{
      MyMessageHandler.showSnackBar(_scaffoldkey, 'Please select a category!');
    }
  }

  void uploadData() async{
    if(imagesUrlList.isNotEmpty){
      CollectionReference productRef = FirebaseFirestore.instance.collection('products');
      productId = const Uuid().v4();
      await productRef.doc(name+"-"+productId).set({
        'id': name+"-"+productId,
        'category': categValue,
        'actualPrice': actualPrice.toString(),
        'stock': stock.toString(),
        'name': name,
        'des': des,
        'shortDes': shortDes,
        'tags': tagsList,
        'discount': '0',
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'email': FirebaseAuth.instance.currentUser!.email,
        'images': imagesUrlList,
        'sellPrice': actualPrice.toString(),
        'sizes': sizeList,
      }).whenComplete((){
        setState((){
          imagesFileList = [];
          categValue = ' ';
          tagsList = [];
          imagesUrlList = [];
          processing = false;
        });
        _formKey.currentState!.reset();
      });
    }else{
      print('no images');
    }
  }
  void uploadProduct() async{
      await uploadImagesOnly().whenComplete(() => uploadData());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Add Product'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child:Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: Colors.blueGrey.shade100,
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: imagesFileList != null ? previewImages():
                        const Center(
                          child: Text(
                            'You have not \n \n picked images yet!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const Text('Select Category'),
                          DropdownButton(
                            value: categValue,
                              items: categories
                                  .map<DropdownMenuItem<String>>((value){
                                    return DropdownMenuItem(
                                        child: Text(value),
                                        value: value,
                                    );
                              }).toList(),
                              onChanged: (String? value){
                                setState((){
                                  categValue = value!;
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter a price!';
                          }else if(value.isValidPrice() != true) {
                            return 'Not valid price';
                          }
                          return null;
                        },
                        onSaved: (value){
                          actualPrice = value!;
                        },
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: textFormDecoration.copyWith(
                          labelText: 'price',
                          hintText: 'price .. \$',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter stock!';
                          } else if(value.isValidQuantity() != true){
                            return 'Not valid stock!';
                          }
                          return null;
                        },
                        onSaved: (value){
                          stock = value!;
                        },
                        keyboardType: TextInputType.number,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Stock',
                          hintText: 'Stock',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter a product name!';
                          } return null;
                        },
                        onSaved: (value){
                          name = value!;
                        },
                        maxLength: 100,
                        maxLines: 3,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Name',
                          hintText: 'Product Name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter a description!';
                          } return null;
                        },
                        onSaved: (value){
                          des = value!;
                        },
                        maxLength: 800,
                        maxLines: 6,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Description',
                          hintText: 'Description',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter a short description!';
                          } return null;
                        },
                        onSaved: (value){
                          shortDes = value!;
                        },
                        maxLength: 300,
                        maxLines: 4,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Short Description',
                          hintText: 'Short Description',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter tags!';
                          } return null;
                        },
                        onSaved: (value){
                          tags = value!;
                        },
                        maxLength: 200,
                        maxLines: 6,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Tags',
                          hintText: 'Tags to be searchable',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                heroTag: 'btn1',
                onPressed: imagesFileList!.isEmpty
                    ? (){
                  _pickProductImages();
                } : () {
                  setState((){
                    imagesFileList = [];
                  });
                },
                backgroundColor: Colors.blueAccent,
                child: imagesFileList!.isEmpty
                  ?const Icon(
                    Icons.photo_album,
                  color: Colors.white,
                )
                    : const Icon(Icons.delete,
                color: Colors.white,),
              ),
            ),
            FloatingActionButton(
              heroTag: 'btn2',
              onPressed: processing == true ? null :(){
                uploadProduct();
              },
              backgroundColor: Colors.blueAccent,
              child: processing == true ? const CircularProgressIndicator(color: Colors.white): const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
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


extension QuantityValidator on String{
  bool isValidQuantity (){
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String{
  bool isValidPrice (){
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$').hasMatch(this);
  }
}

extension DiscountValidator on String{
  bool isValidDiscount (){
    return RegExp(r'^[0-9][0-9]*$').hasMatch(this);
  }
}

