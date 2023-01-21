import 'dart:math';
import 'package:provider/provider.dart';
import 'package:book_app/provider/book_provider.dart';
import 'package:flutter/material.dart';
import 'book_detail_screen.dart';
import '../widgets/single_book_item.dart';
import '../model/book.dart';

class SingleCategoryPage extends StatefulWidget {
  const SingleCategoryPage({super.key});
  static const routeArgs = '/singleCategoryPage';

  @override
  State<SingleCategoryPage> createState() => _SingleCategoryPageState();
}

class _SingleCategoryPageState extends State<SingleCategoryPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> cat =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(cat.keys.first),
      ),
      body: FutureBuilder(
        future: Provider.of<BookProvider>(context, listen: false)
            .getBooks(cat.values.first),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Consumer<BookProvider>(
                    builder: (ctx, bookProvider, _) {
                      List<Book> lst = bookProvider.animeAndMangaList;
                      if (cat.values.first == 'arts+entertainment') {
                        lst = bookProvider.artsAndEntertainmentList;
                      } else if (cat.values.first == 'engineering') {
                        lst = bookProvider.engineeringList;
                      } else if (cat.values.first == 'buisness+investing') {
                        lst = bookProvider.businessList;
                      } else if (cat.values.first == 'computers+technolgy') {
                        lst = bookProvider.computerTechnologyList;
                      } else if (cat.values.first == 'cooking+food+wine') {
                        lst = bookProvider.cookingList;
                      } else if (cat.values.first == 'fiction+literature') {
                        lst = bookProvider.fictionList;
                      } else if (cat.values.first == 'health+mind+body') {
                        lst = bookProvider.healthList;
                      } else if (cat.values.first == 'horror') {
                        lst = bookProvider.horrorList;
                      } else if (cat.values.first == 'action+adventure') {
                        lst = bookProvider.actionAndAdventureList;
                      } else if (cat.values.first == 'novel') {
                        lst = bookProvider.novelList;
                      } else if (cat.values.first == 'anime+manga') {
                        lst = bookProvider.animeAndMangaList;
                      } else {
                        lst = bookProvider.historyList;
                      }

                      return ListView.builder(
                        itemBuilder: (context, ind) =>
                            SingleBookItem(lst[ind], ind),
                        itemCount: lst.length,
                      );
                    },
                  ),
      ),
    );
  }
}
