class ChapterModel {
  final String id;
  final String name;
  final List<String> chapterUrl;

  ChapterModel({
    required this.id,
    required this.name,
    required this.chapterUrl
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) { 
    return ChapterModel( 
      id: json['_id'] as String, 
      name: json['name'] as String, 
      chapterUrl: json['chapterUrl']  , 
      ); 
  }
}