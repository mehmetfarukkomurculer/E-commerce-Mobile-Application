import 'package:flutter/material.dart';
import 'package:untitled3/screens/productmanager_dashboard.dart';
import 'package:untitled3/screens/home.dart';


class ProductManagerHomeScreen extends StatefulWidget {
  const ProductManagerHomeScreen({Key? key}) : super(key: key);

  @override
  _ProductManagerHomeScreenState createState() => _ProductManagerHomeScreenState();
}

class _ProductManagerHomeScreenState extends State<ProductManagerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    ProductManagerDashboardScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        onTap: (index){
          setState((){
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}