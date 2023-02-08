import 'package:flutter/material.dart';
import 'single_category_page.dart';
import 'search_screen.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  List<Map<String, String>> genres = [
    {'Arts & entertainment': 'arts+entertainment'},
    {'Engineering': 'engineering'},
    {'Business &  investing': 'buisness+investing'},
    {'Computers & technology': 'computers+technolgy'},
    {'Cooking,food & wine': 'cooking+food+wine'},
    {'Fiction & literature': 'fiction+literature'},
    {'Health,mind and Body': 'health+mind+body'},
    {'Horror': 'horror      '},
    {'Action & adventure': 'action+adventure'},
    {'Novel': 'novel    '},
    {'Anime & Manga': 'anime+manga'},
    {'History': 'history        '},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Genres'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchScreen())),
              icon: Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            ...genres
                .map((topic) => InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                          SingleCategoryPage.routeArgs,
                          arguments: topic),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          child: Text(
                            topic.keys.first,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        )),
      ),
    );
  }
}
