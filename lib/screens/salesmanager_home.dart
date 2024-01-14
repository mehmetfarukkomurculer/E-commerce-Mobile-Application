import 'package:flutter/material.dart';
import 'package:untitled3/screens/home.dart';
import 'package:untitled3/screens/salesmanager_dashboard.dart';


class SalesManagerHomeScreen extends StatefulWidget {
  const SalesManagerHomeScreen({Key? key}) : super(key: key);

  @override
  _SalesManagerHomeScreenState createState() => _SalesManagerHomeScreenState();
}

class _SalesManagerHomeScreenState extends State<SalesManagerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    SalesManagerDashboardScreen(),
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