import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bebks_ebooks/models/environment.dart';
import 'package:bebks_ebooks/models/bannerModel.dart';
import 'package:bebks_ebooks/models/bookModel.dart';
import 'package:bebks_ebooks/models/chapterModel.dart';

class BannerApi {
  static Future<List<AppBanner>> fetchBanners() async {
    final uri = Uri.parse('${Environment.apiUrl}/api/banner');
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final result = json as List<dynamic>;
    final banner = result.map((e) {
      return AppBanner(
        bannerUrl: e['bannerUrl']
      );
    }).toList();
    return banner;
  }
}

class ChapterApi {
  static String? chapterId;

  static Future<List<ChapterModel>> fetchChapters() async {
    final uri = Uri.parse('${Environment.apiUrl}/v1/chapters/${chapterId}');
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final result = json as List<dynamic>;
    final chapter = result.map((e) {
      return ChapterModel(
        name: e['name'],
        chapterUrl:  e['chapterUrl']
      );
    }).toList();
    return chapter;
  }
}

class BookApi {
  static String? bookId;

  static Future<List<BookModel>> fetchBooks() async {
    final uri = Uri.parse('${Environment.apiUrl}/v1/books/get');
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final result = json as List<dynamic>;
    final book = result.map((e) {
      return BookModel(
        title: e['title'],
        coverImage: e['coverImage']
      );
    }).toList();
    return book;
  }
}