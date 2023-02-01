import 'package:book_app/provider/user_Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../provider/book_provider.dart';

class BookDetailScreen extends StatefulWidget {
  String? bookId;
  BookDetailScreen(this.bookId, {super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CreateWishListIcon(widget.bookId!),
        ],
      ),
      body: FutureBuilder<Book>(
          future: Provider.of<BookProvider>(context, listen: false)
              .getBookDetail(widget.bookId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Book tempBook = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.5),
                                  child: Image.network(
                                    tempBook.imageLinks.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${tempBook.title}',
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontSize: 29,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(''),
                                  Text('${tempBook.author}'),
                                  Text(
                                      'Published At ${tempBook.publishedDate}'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                                child: FittedBox(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('${tempBook.averageRating}'),
                                      const Icon(
                                        Icons.star,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                  Text('${tempBook.ratingCount} reviews'),
                                ],
                              ),
                            )),
                            const VerticalDivider(thickness: 1.5),
                            Expanded(
                                child: Column(
                              children: const [
                                Icon(
                                  Icons.book,
                                  size: 15,
                                ),
                                Text('eBook')
                              ],
                            )),
                            const VerticalDivider(thickness: 1.5),
                            Expanded(
                                child: Column(
                              children: [
                                Text('${tempBook.pageCount}'),
                                const Text('Pages')
                              ],
                            ))
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(thickness: 1.5),
                      ),
                      Text('Description',
                          style: Theme.of(context).textTheme.headline3),
                      Text('${tempBook.description}')
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class CreateWishListIcon extends StatefulWidget {
  String bookId;

  CreateWishListIcon(this.bookId, {super.key});

  @override
  State<CreateWishListIcon> createState() => _CreateWishListIconState();
}

class _CreateWishListIconState extends State<CreateWishListIcon> {
  bool? _isBookMarked = false;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    checkBookMark();
    super.initState();
  }

  Future<void> checkBookMark() async {
    // DocumentSnapshot<Map<String, dynamic>> snapDoc = await FirebaseFirestore
    //     .instance
    //     .collection('users')
    //     .doc(user.uid)
    //     .collection('wishList')
    //     .doc(widget.bookId)
    //     .get();
    // if (snapDoc.exists) {
    //   setState(() {
    //     _isBookMarked = true;
    //   });
    // } else {
    //   setState(() {
    //     _isBookMarked = false;
    //   });
    // }
    bool bookMarked = await Provider.of<UserProvider>(context, listen: false)
        .isBookMarked(widget.bookId);
    setState(() {
      _isBookMarked = bookMarked;
    });
  }

  Future<void> changeBookMark() async {
    if (!_isBookMarked!) {
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .collection('wishList')
      //     .doc(widget.bookId)
      //     .set({'boodId': widget.bookId});
      await Provider.of<UserProvider>(context, listen: false)
          .addBookIntoWishList(widget.bookId);
    } else {
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .collection('wishList')
      //     .doc(widget.bookId)
      //     .delete();
      await Provider.of<UserProvider>(context, listen: false)
          .removeBookFromWishList(widget.bookId);
    }
    setState(() {
      _isBookMarked = !_isBookMarked!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await changeBookMark();
      },
      icon: _isBookMarked!
          ? const Icon(Icons.bookmark_add)
          : const Icon(Icons.bookmark_add_outlined),
    );
  }
}
