import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/comment.dart';

class EditAddComment extends StatefulWidget {
  bool? isEdit;
  Comment? comment;
  Function submit;

  EditAddComment(this.isEdit, this.comment, this.submit, {super.key});

  @override
  State<EditAddComment> createState() => _EditAddCommentState();
}

class _EditAddCommentState extends State<EditAddComment> {
  final _formKey = GlobalKey<FormState>();
  int _initialRating = 0;
  String? _initialComment = '';
  String? loginUserId;
  @override
  void initState() {
    _initialRating = widget.comment!.star!;
    _initialComment = widget.comment!.text;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: widget.isEdit!
            ? const Text('Edit Review')
            : const Text('Write a review'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                onPressed: _initialRating == 0.0
                    ? null
                    : () async {
                        widget.comment!.text = _initialComment;
                        widget.comment!.star = _initialRating;
                        //_submitReviewChanges;
                        await widget.submit();
                        Navigator.of(context).pop();
                      },
                child: const Text('Submit')),
          )
        ],
        shape: const Border(bottom: BorderSide.none),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              RatingBar.builder(
                initialRating: _initialRating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                updateOnDrag: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _initialRating = rating.toInt();
                  });
                },
              ),
              const SizedBox(height: 30),
              Form(
                  key: _formKey,
                  child: TextFormField(
                    initialValue: _initialComment,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        _initialComment = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Describe your Experience (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
