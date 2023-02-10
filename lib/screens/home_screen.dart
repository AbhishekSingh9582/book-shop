import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/widgets/category_item.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Google Play Book'),
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
              Text('Horror', style: Theme.of(context).textTheme.headline2),
              CategoryItem('horror'),
              const SizedBox(height: 3),
              Text('Literature', style: Theme.of(context).textTheme.headline2),
              CategoryItem('action+adventure'),
              const SizedBox(height: 3),
              Text('Anime Manga', style: Theme.of(context).textTheme.headline2),
              CategoryItem('anime+manga'),
              const SizedBox(height: 3),
              Text('Fiction', style: Theme.of(context).textTheme.headline2),
              CategoryItem('fiction'),
              const SizedBox(height: 3),
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
