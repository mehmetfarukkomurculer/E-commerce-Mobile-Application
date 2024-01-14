import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/auth/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {

  late String name;
  late String email;
  late String password;
  late String number; //tax ID
  late String _uid;
  String wallet = '0';
  bool seller = false;
  bool tac = true;
  bool productManager = false;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void register() async {
    setState((){
      processing = true;
    });
    if(_formKey.currentState!.validate()){
      try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

          _uid = FirebaseAuth.instance.currentUser!.uid;

          await users.doc(_uid).set({
            'name' : name,
            'email': email,
            'number': number,
            'password': password,
            'address': '',
            'phone': '',
            'cid': _uid,
            'seller': seller,
            'productManager': productManager,
            'tac': tac,
            'wallet': wallet,
          });
          _formKey.currentState!.reset();
          Navigator.pushReplacementNamed(context, '/customer_home');
          } on FirebaseAuthException catch(e){
          if(e.code == 'weak-password'){
            setState((){
              processing = false;
            });
            MyMessageHandler.showSnackBar(_scaffoldkey, 'The password provided is too weak.');
          }else if(e.code == 'email-already-in-use'){
            setState((){
              processing = false;
            });
            MyMessageHandler.showSnackBar(_scaffoldkey, 'The account already exists for that email.');
          }
        }
    } else {
      setState((){
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldkey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Register', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                          IconButton(
                              onPressed: (){
                                Navigator.pushReplacementNamed(context, '/welcome_screen');
                              },
                              icon: const Icon(Icons.home_work_outlined, size: 40)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onChanged: (value){
                            name = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter your e-mail';
                            }else if(value.isValidEmail() == false){
                              return 'Please enter a valid e-mail';
                            }else if(value.isValidEmail() == true){
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value){
                            email = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'Enter your e-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter your password';
                            }else if(value.length < 6){
                              return 'Password cannot be shorter than 6';
                            }
                            return null;
                          },
                          onChanged: (value){
                            password = value;
                          },
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState((){
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter your tax ID';
                            }
                            else if(value.length < 10){
                              return 'Tax ID cannot be shorter than 10';
                            }
                            return null;
                          },
                          onChanged: (value){
                            number = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'TaxID',
                            hintText: 'Enter your tax ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pushReplacementNamed(context, '/customer_login');
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),),
                          ),
                        ],
                      ),
                      Material(
                        color: Colors.black,
                        child: processing == true ? const CircularProgressIndicator(): MaterialButton(onPressed:(){
                          register();
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                         ),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


