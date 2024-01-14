import 'package:flutter/material.dart';

List<String> labels = [
  'my store',
  'orders',
  'edit profile',
];

List<Image> images = [
  Image.asset('assets/images/comicbooks.png'),
  Image.asset('assets/images/boardgames.png'),
  Image.asset('assets/images/rpg.png'),
];


class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black54,
        title: const Text(
            'Categories'
        ),
      ),
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
