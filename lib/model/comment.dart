class Comment {
  String? uid;
  String? username;
  String? text;
  DateTime? createdAt;
  int? star;
  String? bookId;

  Comment(
      {this.uid,
      this.createdAt,
      this.star,
      this.text,
      this.username,
      this.bookId});

  Comment.fromJson(Map<String, dynamic> json) {
    uid = json['userId'];
    username = json['username'];
    text = json['text'];
    createdAt = json['createdAt'].toDate();
    star = json['star'];
    bookId = json['bookId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = uid;
    data['username'] = username;
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['star'] = star;
    data['bookId'] = bookId;
    return data;
  }
}
