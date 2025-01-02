class BookModel{
  final String id;
  final String title;
  final String coverImage;
  final String author;
  final List<dynamic>? chapters;

  BookModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.author,
    this.chapters
  });

}