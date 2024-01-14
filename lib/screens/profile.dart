import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/customer_screens/customer_orders.dart';
import 'package:untitled3/customer_screens/wishlist.dart';
import 'package:untitled3/screens/cart.dart';
import '../widgets/alertdialog.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController controller;
  String edited_address = '';
  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');
  Future<String?> openDialog() => showDialog<String>(
    context: context,
    builder: (context)=> AlertDialog(
      title: Text('Edit Address'),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Enter your address'),
        controller: controller,
      ),
      actions: [
        TextButton(
        onPressed: update,
            child: const Text('Update'),
        ),
      ],
    ),
  );
  void update(){
    Navigator.of(context).pop(controller.text);
  }
  /*await FirebaseFirestore.instance.collection('users').doc().update({
  'deliverystatus':'shipping',
  'deliverydate':date,
  });*/
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseAuth.instance.currentUser!.isAnonymous
            ? anonymous.doc(widget.documentId).get()
            :users.doc(widget.documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasError) {
            return const Text('Something went wrong');
          }if(snapshot.hasData && !snapshot.data!.exists){
            return const Text('Document does not exist');
          }if(snapshot.connectionState == ConnectionState.done){
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Colors.brown,
              body: Stack(
                children: [
                  Container(
                    height: 243,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.brown,
                        Colors.yellow,
                      ]),
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        centerTitle: true,
                        elevation: 0,
                        backgroundColor: Colors.yellow.shade600,
                        expandedHeight: 140,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints){
                            return FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: constraints.biggest.height <= 120 ? 1 : 0,
                                child: const Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              background: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.brown, Colors.yellow])),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:25, left: 30),
                                  child: Row(
                                    children: [
                                      const Text('Welcome ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 25),
                                          child: Text(
                                            data['name'].toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      ),
                                    ),
                                    child: TextButton(
                                      child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          child: const Center(
                                            child: Text(
                                              'Cart',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.brown,
                                    child: TextButton(
                                      child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          child: const Center(
                                            child: Text(
                                              'Orders',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerOrders()));
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: TextButton(
                                      child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          child: const Center(
                                            child: Text(
                                              'Wishlist',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistScreen()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.brown,
                              child: Column(
                                children: [ const SizedBox (
                                  height: 30,
                                ),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          height: 40,
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                        Text(
                                          '  Account Info  ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 450,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          ListTile(
                                            title: const Text('E-mail'),
                                            subtitle: Text(data['email']),
                                            leading: const Icon(Icons.email),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: Divider(
                                              color: Colors.black54,
                                              thickness: 1,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){},
                                            child: ListTile(
                                              title: const Text('Phone Number'),
                                              subtitle: Text(data['phone']),
                                              leading: const Icon(Icons.phone),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: Divider(
                                              color: Colors.black54,
                                              thickness: 1,
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Address'),
                                            subtitle: Text(data['address']),
                                            leading: const Icon(Icons.home_work_outlined),
                                            trailing: IconButton(
                                              onPressed: ()async{
                                                final editedAddress = await openDialog();
                                                if(editedAddress == null ||  editedAddress.isEmpty) return;
                                                setState(() => this.edited_address = editedAddress);
                                                await FirebaseFirestore.instance.collection('users').doc(data['cid']).update({
                                                  'address':editedAddress,
                                                });
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: Divider(
                                              color: Colors.black54,
                                              thickness: 1,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){

                                            },
                                            child: ListTile(
                                              title: const Text('Tax ID'),
                                              subtitle: Text(data['number']),
                                              leading: const Icon(Icons.money),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: Divider(
                                              color: Colors.black54,
                                              thickness: 1,
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Wallet'),
                                            subtitle: Text(data['wallet'].toStringAsFixed(2)),
                                            leading: const Icon(Icons.attach_money),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          height: 40,
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                        Text(
                                          '  Account Settings  ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 265,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: (){},
                                            child: const ListTile(
                                              title: Text('Edit Profile'),
                                              leading: Icon(Icons.edit),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: Divider(
                                              color: Colors.black54,
                                              thickness: 1,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){},
                                            child: const ListTile(
                                              title: Text('Change Password'),
                                              leading: Icon(Icons.lock),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: Divider(
                                              color: Colors.black54,
                                              thickness: 1,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              MyAlertDialog.showMyDialog(
                                                  context: context,
                                                  title: 'Log out',
                                                  content: 'Are you sure to log out?',
                                                  tabno: (){Navigator.pop(context);},
                                                  tabyes: () async {
                                                    await FirebaseAuth.instance.signOut();
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacementNamed(
                                                        context, '/welcome_screen');
                                                  });
                                            },
                                            child: const ListTile(
                                              title: Text('Log Out'),
                                              leading: Icon(Icons.logout),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );

          }
          return const Text('loading');
        }
    );

  }
}

