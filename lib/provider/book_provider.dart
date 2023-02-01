import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/book.dart';

class BookProvider with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser!;

  List<Book> _fictionCollection = [];
  List<Book> _wishListBooks = [];
  List<Book> _searchList = [];

  List<Book> _animeAndMangaCollection = [];
  List<Book> _actionAndAdventureCollection = [];
  List<Book> _novelCollection = [];
  List<Book> _horrorCollection = [];
  List<Book> _ArtsAndEntertainmetCollection = [];
  List<Book> _engineeringCollection = [];
  List<Book> _buisnessAndInvestingCollection = [];
  List<Book> _healthMindBodyCollection = [];
  List<Book> _historyCollection = [];
  List<Book> _cookingFoodWineCollection = [];
  List<Book> _computerTechnologyCollection = [];

  List<Book> get searchList {
    return [..._searchList];
  }

  List<Book> get wishList {
    return [..._wishListBooks];
  }

  List<Book> get fictionList {
    return [..._fictionCollection];
  }

  List<Book> get animeAndMangaList {
    return [..._animeAndMangaCollection];
  }

  List<Book> get actionAndAdventureList {
    return [..._actionAndAdventureCollection];
  }

  List<Book> get novelList {
    return [..._novelCollection];
  }

  List<Book> get horrorList {
    return [..._horrorCollection];
  }

  List<Book> get artsAndEntertainmentList {
    return [..._ArtsAndEntertainmetCollection];
  }

  List<Book> get engineeringList {
    return [..._engineeringCollection];
  }

  List<Book> get businessList {
    return [..._buisnessAndInvestingCollection];
  }

  List<Book> get healthList {
    return [..._healthMindBodyCollection];
  }

  List<Book> get historyList {
    return [..._historyCollection];
  }

  List<Book> get cookingList {
    return [..._cookingFoodWineCollection];
  }

  List<Book> get computerTechnologyList {
    return [..._computerTechnologyCollection];
  }

  Future<void> getBooks(String cat) async {
    final url = Uri.parse(
        "https://www.googleapis.com/books/v1/volumes?q=$cat&maxResults=15");
    // final url = Uri.https("www.googleapis.com", "books/v1/volumes", {
    //   'q': 'Fiction',
    //   'key': '',
    //   'maxResults': '40',
    // });

    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      Map<String, dynamic> result =
          json.decode(response.body) as Map<String, dynamic>;

      if (!result.containsKey('error')) {
        List<Book> tempList = [];

        result['items']!.forEach((book) {
          if (book['volumeInfo'] != null) {
            Map<String, dynamic> volumeInfo = book['volumeInfo'] ?? {};

            Map<String, dynamic> imageUrl = volumeInfo['imageLinks'] ??
                {
                  'smallThumbnail':
                      'http://books.google.com/books/content?id=1M0Y2RYqffIC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'
                };
            tempList.add(Book(
              id: book['id'],
              title: volumeInfo['title'] ?? '',
              author: volumeInfo['authors'] != null
                  ? (volumeInfo['authors'] as List<dynamic>)
                      .map((author) => author.toString())
                      .toList()
                  : [''],
              publishedDate: volumeInfo['publishedDate'],
              averageRating: volumeInfo['averageRating'] == null
                  ? '__'
                  : volumeInfo['averageRating'].toString(),
              pageCount: volumeInfo['pageCount'],
              imageLinks: imageUrl['smallThumbnail'],
              description: volumeInfo['description'],
              ratingCount: volumeInfo['ratingsCount'],
            ));
          }
        });

        if (tempList.isNotEmpty) {
          if (cat == 'fiction') {
            _fictionCollection = tempList;
          } else if (cat == 'action+adventure') {
            _actionAndAdventureCollection = tempList;
          } else if (cat == 'anime+manga') {
            _animeAndMangaCollection = tempList;
          } else if (cat == 'novel') {
            _novelCollection = tempList;
          } else if (cat == 'horror') {
            _horrorCollection = tempList;
          } else if (cat == 'arts+entertainment') {
            _ArtsAndEntertainmetCollection = tempList;
          } else if (cat == 'engineering') {
            _engineeringCollection = tempList;
          } else if (cat == 'buisness+investing') {
            _buisnessAndInvestingCollection = tempList;
          } else if (cat == 'computers+technolgy') {
            _computerTechnologyCollection = tempList;
          } else if (cat == 'cooking+food+wine') {
            _cookingFoodWineCollection = tempList;
          } else if (cat == 'health+mind+body') {
            _healthMindBodyCollection = tempList;
          } else {
            _historyCollection = tempList;
          }

          notifyListeners();
        }
      } else {
        print('1 page book_provider ${result['error']}');
      }
    } catch (e) {
      print('2 error Occured in book_provider $e');
    }
  }

  Future<Book> getBookDetail(String? id) async {
    var url = Uri.parse('https://www.googleapis.com/books/v1/volumes/$id');
    final response = await http.get(url);
    //print(json.decode(response.body));

    Map<String, dynamic> result =
        json.decode(response.body) as Map<String, dynamic>;
    Map<String, dynamic> volumeInfo =
        result['volumeInfo'] as Map<String, dynamic>;

    return Book(
      title: volumeInfo['title'] ?? '',
      id: id,
      author: volumeInfo['authors'] != null
          ? (volumeInfo['authors'] as List<dynamic>)
              .map((author) => author.toString())
              .toList()
          : [''],
      publishedDate: volumeInfo['publishedDate'],
      pageCount: volumeInfo['pageCount'],
      averageRating: volumeInfo['averageRating'] == null
          ? '0'
          : volumeInfo['averageRating'].toString(),
      imageLinks: volumeInfo['imageLinks']['smallThumbnail'],
      description: volumeInfo['description'],
      ratingCount: volumeInfo['ratingsCount'] ?? 0,
    );
  }

  Future<void> getWishListBook(List<String> idList) async {
    List<Book>? tempwishList = [];
    // final querysnapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.uid)
    //     .collection('wishList')
    //     .get();

    for (var docSnap in idList) {
      // Book book = await Provider.of<BookProvider>(context, listen: false)
      //     .getBookDetail(docSnap.id);
      Book book = await getBookDetail(docSnap);
      //print(docSnap.id);
      tempwishList.add(book);
    }

    _wishListBooks = tempwishList;
    // notifyListeners();
    //return wishListBooks;
  }

  Future<void> getSearchList(String? search) async {
    List<Book> tempList = [];
    if (search == '') {
      _searchList = tempList;
      return;
    }

    var url =
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$search');

    final response = await http.get(url);

    try {
      //print(json.decode(response.body));
      Map<String, dynamic> result =
          json.decode(response.body) as Map<String, dynamic>;

      if (!result.containsKey('error')) {
        result['items']!.forEach((book) {
          print(book['volumeInfo']['title']);

          if (book['volumeInfo'] != null) {
            Map<String, dynamic> volumeInfo = book['volumeInfo'] ?? {};

            Map<String, dynamic> imageUrl = volumeInfo['imageLinks'] ??
                {
                  'smallThumbnail':
                      'http://books.google.com/books/content?id=1M0Y2RYqffIC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'
                };
            tempList.add(Book(
              id: book['id'],
              title: volumeInfo['title'] ?? '',
              author: volumeInfo['authors'] != null
                  ? (volumeInfo['authors'] as List<dynamic>)
                      .map((author) => author.toString())
                      .toList()
                  : [''],
              publishedDate: volumeInfo['publishedDate'],
              averageRating: volumeInfo['averageRating'] == null
                  ? '__'
                  : volumeInfo['averageRating'].toString(),
              pageCount: volumeInfo['pageCount'],
              imageLinks: imageUrl['smallThumbnail'],
              description: volumeInfo['description'],
              ratingCount: volumeInfo['ratingsCount'],
            ));
          }
        });
        _searchList = tempList;
      } else {
        print('1 page book_provider ${result['error']}');
      }
    } catch (e) {
      print('2 error Occured in book_provider $e');
    }
  }
}
