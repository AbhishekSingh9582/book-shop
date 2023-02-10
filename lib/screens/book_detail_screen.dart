import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_app/provider/user_Provider.dart';
import '../model/book.dart';
import '../provider/book_provider.dart';
import '../model/comment.dart';
import '../model/user.dart';
import 'edit_add_comment.dart';

class BookDetailScreen extends StatefulWidget {
  String? bookId;
  BookDetailScreen(this.bookId, {super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  List<Comment> _commentList = [];
  bool curUserComment = false;
  Users? loginUser;
  Comment? comment;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    loginUser = Provider.of<UserProvider>(context, listen: false).loginUser;

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.bookId)
        .collection('users')
        .doc(loginUser!.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        curUserComment = true;
        comment = Comment.fromJson(data);
      } else {
        curUserComment = false;
        comment = Comment(
            uid: loginUser!.id,
            text: '',
            bookId: widget.bookId,
            createdAt: DateTime.now(),
            star: 0,
            username: loginUser!.name);
      }
    });
  }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text('${tempBook.description}'),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 4,
                        ),
                        child: Text('Reviews and Ratings',
                            style: Theme.of(context).textTheme.headline3),
                      ),
                      CurrentUserCommentSection(
                          widget.bookId, curUserComment, comment, loginUser),

                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('comments')
                              .doc(widget.bookId)
                              .collection('users')
                              .snapshots(),
                          builder: ((context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something is wrong');
                            }
                            if (ConnectionState.waiting ==
                                snapshot.connectionState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasData) {
                              return Column(children: [
                                ...snapshot.data!.docs.map((commentData) {
                                  final comment = commentData.data()
                                      as Map<String, dynamic>;
                                  if (comment['userId'] == loginUser!.id) {
                                    return Container();
                                  }
                                  return CommentWidget(
                                      Comment.fromJson(comment));
                                }).toList()
                              ]);
                            }
                            return const SizedBox();
                          })),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class CurrentUserCommentSection extends StatefulWidget {
  String? bookId;
  bool curUserComment;
  Comment? comment;
  Users? loginUser;
  CurrentUserCommentSection(
      this.bookId, this.curUserComment, this.comment, this.loginUser,
      {super.key});

  @override
  State<CurrentUserCommentSection> createState() =>
      _CurrentUserCommentSectionState();
}

class _CurrentUserCommentSectionState extends State<CurrentUserCommentSection> {

  Future<void> submitReviewChanges() async {
    if (widget.curUserComment == true) {
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.comment!.bookId)
          .collection('users')
          .doc(widget.comment!.uid)
          .update({
        'createdAt': widget.comment!.createdAt,
        'star': widget.comment!.star,
        'text': widget.comment!.text,
      }).then((value) {
        setState(() {
          widget.curUserComment = true;
          
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.comment!.bookId)
          .collection('users')
          .doc(widget.comment!.uid)
          .set(Comment(
            createdAt: DateTime.now(),
            uid: widget.comment!.uid,
            star: widget.comment!.star,
            text: widget.comment!.text,
            bookId: widget.comment!.bookId,
            username: widget.comment!.username,
          ).toJson())
          .then((value) {
        setState(() {
          widget.curUserComment = true;
          
        });
      });
    }
  }

  Future<void> deleteComment() async {
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.comment!.bookId)
        .collection('users')
        .doc(widget.comment!.uid)
        .delete()
        .then((value) {
      setState(() {
        widget.curUserComment = false;
        widget.comment!.star = 0;
        widget.comment!.text = '';
        widget.comment!.createdAt = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.curUserComment
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Divider(thickness: 1.5),
              ),
              const Text(
                'Your Review',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 2.5),
              CommentWidget(widget.comment!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditAddComment(
                                true, widget.comment, submitReviewChanges))),
                    style:
                        OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('Edit Review'),
                  ),
                  OutlinedButton(
                    onPressed: deleteComment,
                    style:
                        OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('Delete'),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Divider(thickness: 1.5),
              ),
              const SizedBox(height: 15),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Divider(thickness: 1.5),
              ),
              const Text(
                'Rate this eBook',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Text('Tell others what you think'),
              const SizedBox(height: 2.5),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditAddComment(
                        false, widget.comment, submitReviewChanges))),
                style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('Write a review'),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Divider(thickness: 1.5),
              ),
              const SizedBox(height: 15),
            ],
          );
  }
}

class CommentWidget extends StatelessWidget {
  Comment commentData;
  CommentWidget(
    this.commentData, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Flexible(child: CircleAvatar(backgroundImage: AssetImage('assets/Images/empty-profile.png'),)),
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8, bottom: 12, top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${commentData.username}',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                            5,
                            (index) => Icon(
                                  index < commentData.star!
                                      ? Icons.star
                                      : Icons.star_border_outlined,
                                  size: 18.5,
                                  color: Colors.orange,
                                )),
                        const SizedBox(width: 13),
                        Text(DateFormat.yMMMEd().format(commentData.createdAt!))
                      ],
                    ),
                  ),
                  Text(
                    '${commentData.text}',
                    softWrap: true,
                  ),
                ],
              ),
            ))
      ],
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
    bool bookMarked = Provider.of<UserProvider>(context, listen: false)
        .isBookMarked(widget.bookId);
    setState(() {
      _isBookMarked = bookMarked;
    });
  }

  Future<void> changeBookMark() async {
    if (!_isBookMarked!) {
      await Provider.of<UserProvider>(context, listen: false)
          .addBookIntoWishList(widget.bookId);
    } else {
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
