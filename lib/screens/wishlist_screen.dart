import 'package:book_app/provider/user_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
                  child: WishlistShimmerEffect(),
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

class WishlistShimmerEffect extends StatelessWidget {
  const WishlistShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: ((context, index) => Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 221, 220, 220),
                highlightColor: const Color.fromARGB(255, 234, 232, 232),
                enabled: true,
                child: Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 170,
                        width: 125,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 16,
                                margin: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            Container(
                                height: 12,
                                margin: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            Container(
                                height: 12,
                                width: 40,
                                margin: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
