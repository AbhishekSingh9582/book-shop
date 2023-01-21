import 'dart:math';
import 'package:flutter/material.dart';
import '../model/book.dart';
import '../screens/book_detail_screen.dart';

class SingleBookItem extends StatelessWidget {
  int index;
  Book book;
  SingleBookItem(this.book, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      // height: 27,
      margin: const EdgeInsets.all(15),

      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => BookDetailScreen(book.id))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (index + 1).toString(),
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.5),
                  child: Image.network(
                    book.imageLinks.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${book.title}',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  ...(book.author as List<String>).map(
                    (e) => Text('$e '),
                  ),
                  Row(children: [
                    Text('eBook ${book.averageRating}'),
                    Icon(
                      Icons.star,
                      size: 13,
                    )
                  ]),
                  Text('Rs ${Random().nextInt(500)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
