class BookModel{
  String title;
  String? category;
  List<dynamic>? chapter;
  String coverImage;

  BookModel({
    required this.title,
    this.category,
    this.chapter,
    required this.coverImage,
});

}