import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');
  late String _uid;
  late String wallet;
  bool processing = false;
  bool seller = false;
  bool tac = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 220,
                  width: 200,
                  child: Image(image: AssetImage('assets/images/logo.jpg')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 50)
                        ),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/customer_login');
                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                        ),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/customer_register');
                        },
                        child: const Text(
                          'Register',
                        ),
                      ),
                    ],
                  ),
                ),
                /*const SizedBox(
                  height: 25,
                ),
                const Text(
                  'For Sales Managers',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 50)
                        ),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/salesmanager_login');
                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 50)
                        ),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/salesmanager_register');
                        },
                        child: const Text(
                          'Register',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'For Product Managers',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 50)
                        ),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/productmanager_login');
                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 50)
                        ),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/productmanager_register');
                        },
                        child: const Text(
                          'Register',
                        ),
                      ),
                    ],
                  ),
                ),*/
                const SizedBox(
                  height: 15,
                ),
                processing == true ? const CircularProgressIndicator():ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () async {
                    setState((){
                      processing = true;
                    });
                    await FirebaseAuth.instance.signInAnonymously().whenComplete(() async {
                      _uid = FirebaseAuth.instance.currentUser!.uid;
                      await anonymous.doc(_uid).set({
                        'name' : 'GUEST',
                        'email': '',
                        'number': '',
                        'password': '',
                        'address': '',
                        'phone': '',
                        'cid': _uid,
                        'seller': seller,
                        'tac': tac,
                        'wallet': '0.0',
                      });
                    });
                    Navigator.pushReplacementNamed(context, '/customer_home');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const[
                      Text(
                        'Continue as a Guest',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
