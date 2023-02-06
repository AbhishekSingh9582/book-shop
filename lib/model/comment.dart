class Comment {
  String? username;
  String? text;
  DateTime? createdAt;
  int? star;

  Comment({this.createdAt, this.star, this.text, this.username});

  Comment.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    text = json['text'];
    createdAt = json['createdAt'].toDate();
    star = json['star'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['star'] = star;
    return data;
  }
}
