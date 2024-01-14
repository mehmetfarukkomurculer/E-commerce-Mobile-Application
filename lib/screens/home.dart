import 'package:flutter/material.dart';
import 'package:untitled3/galleries/boardgames.dart';
import 'package:untitled3/galleries/comicbooks.dart';
import 'package:untitled3/galleries/rpg.dart';

import '../minor_screens/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const SearchScreen())
              );
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.search, color: Colors.grey,)),
                      Text('What are you looking for?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  Container(
                    height: 32,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25)),
                    child: const Center(
                      child: Text(
                        'Search',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottom: const TabBar(
            //isScrollable: true,
            indicatorColor: Colors.black,
            indicatorWeight: 3,
            tabs: [
              RepeatedTab(label:'Comic Books'),
              RepeatedTab(label:'Board Games'),
              RepeatedTab(label:'RPG'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ComicBooks(),
            BoardGames(),
            RPG(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
