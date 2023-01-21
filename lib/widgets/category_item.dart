import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/book_provider.dart';
import '../model/book.dart';
import '../screens/book_detail_screen.dart';

class CategoryItem extends StatefulWidget {
  String cat;
  CategoryItem(this.cat, {super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  Future? _bookFuture;
  @override
  void initState() {
    _bookFuture = _obtainBookFuture();
    super.initState();
  }

  Future _obtainBookFuture() async {
    return Provider.of<BookProvider>(context, listen: false)
        .getBooks('${widget.cat}')
        .catchError((error) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Aww Snap!'),
                content: const Text(
                    'Something went wrong \n\nTry Again Later\nOr check Your Internet connection '),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _obtainBookFuture();
                      },
                      child: const Text('Refresh', textAlign: TextAlign.center),
                    ),
                  )
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bookFuture,
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Container(
              width: 160,
              height: 270,
              child: Center(child: CircularProgressIndicator()))
          : Consumer<BookProvider>(builder: (ctx, bookprovider, _) {
              List<Book>? lst;
              if (widget.cat == 'fiction') {
                lst = bookprovider.fictionList;
              } else if (widget.cat == 'action+adventure') {
                lst = bookprovider.actionAndAdventureList;
              } else if (widget.cat == 'novel') {
                lst = bookprovider.novelList;
              } else if (widget.cat == 'horror') {
                lst = bookprovider.horrorList;
              } else {
                lst = bookprovider.animeAndMangaList;
              }

              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [...lst.map((book) => BookItem(book)).toList()],
                  ));
            }),
    );
  }
}

class BookItem extends StatelessWidget {
  Book book;
  BookItem(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 270,
      margin: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => BookDetailScreen(book.id))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 5 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.5),
                  child: FadeInImage(
                    placeholder:
                        AssetImage('assets/Images/book-cover-placeholder.png'),
                    image: NetworkImage(
                      book.imageLinks.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              '${book.title}',
              style: TextTheme().headline2,
            ),
            Text('Rs ${Random().nextInt(500)}')
          ],
        ),
      ),
    );
  }
}
