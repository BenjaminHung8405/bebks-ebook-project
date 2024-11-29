class ChapterModel {
  final String id;
  final String name;
  final List? chapterUrl;

  ChapterModel({
    required this.id,
    required this.name,
    this.chapterUrl
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) { 
    return ChapterModel( 
      id: json['_id'], 
      name: json['name'], 
      chapterUrl: List<String>.from(json['chapterUrl'] ?? []), 
    ); 
  }
}