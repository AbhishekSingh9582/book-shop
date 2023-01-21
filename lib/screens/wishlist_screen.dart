import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  // int i = 0;
  // void createSection(String bookId) async {
  //   Book book = await Provider.of<BookProvider>(context, listen: false)
  //       .getBookDetail(bookId);
  //   SingleBookItem(book, i++);
  // }
  //List<Book>? wishListBooks = [];
  // @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WishList'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: Provider.of<BookProvider>(context, listen: false)
                .getWishListBook(), //getWishListBook(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) return const Text('Something went wrong');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Consumer<BookProvider>(builder: (ctx, bookProvider, _) {
                List<Book> lst = [];
                lst = bookProvider.wishList;
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
              });
              // if(snapshot.hasData){
              // return snapshot.data!.isEmpty
              //     ? Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             'Keep a list of books to read',
              //             style: Theme.of(context).textTheme.headline3,
              //           ),
              //           const Text('\n'),
              //           const Text(
              //             "To add a book ,tap the wishlist icon in the book's details",
              //             softWrap: true,
              //           )
              //         ],
              //       )
              //     : ListView.builder(
              //         itemBuilder: (context, ind) =>
              //             SingleBookItem(snapshot.data![ind], ind),
              //         itemCount: snapshot.data!.length,
              //       );
            }),
          ),
        ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           StreamBuilder(
  //               stream: FirebaseFirestore.instance
  //                   .collection('users')
  //                   .doc(user.uid)
  //                   .collection('wishList')
  //                   .doc()
  //                   .snapshots(),
  //               builder: (BuildContext context,
  //                   AsyncSnapshot<DocumentSnapshot> snapshot) {
  //                 if (snapshot.hasError) {
  //                   return Text('Something is Wrong');
  //                 }
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return const Center(child: CircularProgressIndicator());
  //                 }
  //                 if (snapshot.hasData) {
  //                   var bookid = snapshot.data!.id;
  //                   print(bookid);
  //                   createSection(bookid);
  //                 }

  //                 return Text('Add into WishList');
  //               }),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
