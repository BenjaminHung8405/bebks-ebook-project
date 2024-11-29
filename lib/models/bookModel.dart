class BookModel{
  final String id;
  final String title;
  final String coverImage;
  final List<dynamic>? chapters;

  BookModel({
    required this.id,
    required this.title,
    required this.coverImage,
    this.chapters
  });

}