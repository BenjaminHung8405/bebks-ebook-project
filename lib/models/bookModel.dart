class BookModel{
  final String id;
  final String title;
  final String coverImage;
  final String author;
  final double rate;
  final List<dynamic>? chapters;

  BookModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.author,
    required this.rate,
    this.chapters
  });

}