import 'package:flutter/material.dart';
import 'single_category_page.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Genres'),
        shape: const Border(
          bottom: BorderSide(color: Color.fromARGB(96, 44, 41, 41), width: 0.6),
          //borderRadius: BorderRadius.only(bottom:Radius.circular(4)),
        ),
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
                      // style: TextButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(vertical: 10)),
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
