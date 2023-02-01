import 'dart:ui';
import 'package:flutter/material.dart';
import '../provider/book_provider.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import '../provider/user_Provider.dart';
import 'category_screen.dart';
import 'wishlist_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getLoginUser();
    super.initState();
  }

  final screens = [
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
                currentIndex = index;
              }),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: 'Wishlist'),
          ]),
    );
  }
}
