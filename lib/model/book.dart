class Book {
  String? id;
  String? title;
  List<String>? author;
  String? publishedDate;
  int? pageCount;

  String? averageRating;
  String? imageLinks;
  String? description;
  int? ratingCount;
  // String? previewLink;

  Book({
    this.id,
    this.title,
    this.author,
    this.publishedDate,
    this.pageCount,
    this.averageRating,
    this.imageLinks = '',
    this.description,
    this.ratingCount,
    // this.previewLink = '',
  });
}
