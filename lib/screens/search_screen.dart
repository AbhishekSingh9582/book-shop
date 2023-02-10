import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../provider/book_provider.dart';
import 'book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books =
        Provider.of<BookProvider>(context, listen: false).searchList;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();

              Provider.of<BookProvider>(context, listen: false)
                  .getSearchList('');
            },
            icon:const Icon(Icons.arrow_back),
          ),
          automaticallyImplyLeading: false,
          title: TextField(
            onChanged: (value) async {
              await Provider.of<BookProvider>(context, listen: false)
                  .getSearchList(value)
                  .then((value) {
                setState(() {});
              });
            },
            decoration: const InputDecoration(
                hintText: 'Search Books',
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
        body: SafeArea(
            child: books.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: ((context, index) => GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    BookDetailScreen(books[index].id)));
                          },
                          child: ListTile(
                            leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(books[index].imageLinks!)),
                              ),
                            ),
                            title: Text(
                              '${books[index].title}',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            subtitle: Text(
                              '${books[index].author}',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        )),
                  )));
  }
}
