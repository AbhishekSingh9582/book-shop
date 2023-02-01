import 'package:book_app/provider/user_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/book_provider.dart';
import '../widgets/single_book_item.dart';
import '../model/book.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> idList = Provider.of<UserProvider>(context).getWishList;

    return Scaffold(
        appBar: AppBar(
          title: const Text('WishList'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: Provider.of<BookProvider>(context, listen: false)
                .getWishListBook(idList),
            builder: ((context, snapshot) {
              if (snapshot.hasError) return const Text('Something went wrong');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<Book> lst = [];

              lst = Provider.of<BookProvider>(context, listen: false).wishList;
              return lst.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Keep a list of books to read',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        const Text('\n'),
                        const Text(
                          "To add a book ,tap the wishlist icon in the book's details",
                          softWrap: true,
                        )
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (context, ind) =>
                          SingleBookItem(lst[ind], ind),
                      itemCount: lst.length,
                    );
            }),
          ),
        ));
  }
}
