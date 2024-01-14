import 'package:flutter/foundation.dart';
import 'package:untitled3/providers/product_class.dart';



class Wishlist extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishlistItems{
    return _list;
  }

  int? get count{
    return _list.length;
  }

  Future<void> addWishlistItem(
      String name,
      double price,
      int qty,
      int qntty,
      List imagesUrl,
      String documentID,
      String supplierID,
      String category,
      )async{
    final product =Product(
      name: name,
      price: price,
      qty: qty,
      qntty: qntty,
      imagesUrl: imagesUrl,
      documentID: documentID,
      supplierID: supplierID,
      category: category,
    );
    _list.add(product);
    notifyListeners();
  }

  void removeItem (Product product){
    _list.remove(product);
    notifyListeners();
  }

  void clearWishlist(){
    _list.clear();
    notifyListeners();
  }
  void removeThis (String id){
    _list.removeWhere((element) => element.documentID == id);
    notifyListeners();
  }

}