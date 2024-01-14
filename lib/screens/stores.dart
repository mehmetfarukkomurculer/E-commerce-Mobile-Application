import 'package:flutter/material.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black54,
        title: const Text(
          'Stores', style: TextStyle(
          color: Colors.white,
        ),
        ),
      ),
    );
  }
}
