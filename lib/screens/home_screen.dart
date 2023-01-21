import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/widgets/category_item.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //user =FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Google Play Book'),
        shape: const Border(
          bottom: BorderSide(color: Color.fromARGB(96, 44, 41, 41), width: 0.6),
        ),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 14,
              ),
              Text('Fiction', style: Theme.of(context).textTheme.headline2),
              CategoryItem('fiction'),
              SizedBox(height: 3),
              Text('Literature', style: Theme.of(context).textTheme.headline2),
              CategoryItem('action+adventure'),
              SizedBox(height: 3),
              Text('Horror', style: Theme.of(context).textTheme.headline2),
              CategoryItem('horror'),
              SizedBox(height: 3),
              Text('Anime Manga', style: Theme.of(context).textTheme.headline2),
              CategoryItem('anime+manga'),
              SizedBox(height: 3),
              Text(
                'Novel',
                style: Theme.of(context).textTheme.headline2,
              ),
              CategoryItem('novel'),
            ],
          ),
        ),
      ),
    );
  }
}
