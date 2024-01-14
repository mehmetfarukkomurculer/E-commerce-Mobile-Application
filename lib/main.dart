import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/auth/customer_login.dart';
import 'package:untitled3/auth/customer_register.dart';
import 'package:untitled3/auth/productmanager_login.dart';
import 'package:untitled3/auth/productmanager_register.dart';
import 'package:untitled3/auth/salesmanager_login.dart';
import 'package:untitled3/auth/salesmanager_register.dart';
import 'package:untitled3/providers/cart_provider.dart';
import 'package:untitled3/providers/wishlist_provider.dart';
import 'package:untitled3/screens/WelcomeScreen.dart';
import 'package:untitled3/screens/customer_home.dart';
import 'package:untitled3/screens/productmanager_home.dart';
import 'package:untitled3/screens/salesmanager_home.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>Cart()),
        ChangeNotifierProvider(create: (_)=>Wishlist())
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/customer_register': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/productmanager_home': (context) => const ProductManagerHomeScreen(),
        '/productmanager_register': (context) => const ProductManagerRegister(),
        '/productmanager_login': (context) => const ProductManagerLogin(),
        '/salesmanager_home': (context) => const SalesManagerHomeScreen(),
        '/salesmanager_register': (context) => const SalesManagerRegister(),
        '/salesmanager_login': (context) => const SalesManagerLogin(),
      },
    );
  }
}



