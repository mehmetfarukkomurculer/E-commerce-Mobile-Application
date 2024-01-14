import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:untitled3/screens/cart.dart';
import 'package:untitled3/screens/home.dart';
import 'package:untitled3/screens/profile.dart';
import 'package:untitled3/screens/stores.dart';
import 'package:badges/badges.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const Center(child: Text('category screen')),
    const StoresScreen(),
    const CartScreen(),
    ProfileScreen(documentId: FirebaseAuth.instance.currentUser!.uid),
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
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Category',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Stores',
          ),
          BottomNavigationBarItem(
              icon: Badge(
                  showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
                  padding: const EdgeInsets.all(3.5),
                  badgeContent: Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart)),
              label: 'Cart',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
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

