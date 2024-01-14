import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/auth/auth_widgets.dart';
import '../widgets/snackbar.dart';

class ProductManagerLogin extends StatefulWidget {
  const ProductManagerLogin({Key? key}) : super(key: key);

  @override
  State<ProductManagerLogin> createState() => _ProductManagerLoginState();
}

class _ProductManagerLoginState extends State<ProductManagerLogin> {

  late String productManagerName;
  late String email;
  late String password;
  late String number; //tax ID
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;


  void logIn() async {
    setState((){
      processing = true;
    });
    if(_formKey.currentState!.validate()){
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        _formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/productmanager_home');
      } on FirebaseAuthException catch(e){
        if(e.code == 'user-not-found'){
          setState((){
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldkey, 'No user found for that email.');
        }else if(e.code == 'wrong-password'){
          setState((){
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldkey, 'Wrong password provided for that user.');
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('PM Log In', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
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
                      TextButton(
                          onPressed: (){},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Don\'t you have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.pushReplacementNamed(context, '/productmanager_register');
                            },
                            child: const Text(
                              'Register',
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
                        child: processing == true
                            ? const Center(child: CircularProgressIndicator())
                            : MaterialButton(
                          onPressed:(){
                            logIn();
                          },
                          child: const Text(
                            'Login',
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