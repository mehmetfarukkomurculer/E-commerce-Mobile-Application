class Product{
  String name;
  double price;
  int qty = 1;
  int qntty;
  List imagesUrl;
  String documentID;
  String supplierID;
  String category;
  Product({
    required this.name,
    required this.price,
    required this.qty,
    required this.qntty,
    required this.imagesUrl,
    required this.documentID,
    required this.supplierID,
    required this.category,
  });
  void increase(){
    qty++;
  }
  void decrease(){
    qty--;
  }
}