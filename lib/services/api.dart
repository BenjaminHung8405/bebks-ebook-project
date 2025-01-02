import 'dart:convert';

import 'package:bebks_ebooks/models/userModel.dart';
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

  static Future<ChapterModel> fetchChapters(String id) async {
    final uri = Uri.parse('${Environment.apiUrl}/v1/chapters/$id');
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final chapter = ChapterModel(
        id: json['_id'] as String,
        name: json['name'],
        chapterUrl:  json['chapterUrl']
      );
    return chapter;
  }
}

class BookApi {
  static Future<List<BookModel>> fetchBooks() async {
    final uri = Uri.parse('${Environment.apiUrl}/v1/books/get');
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final body = response.body;
      final json = jsonDecode(body);
      final result = json as List<dynamic>;
      final book = result.map((e) {
        return BookModel(
          id: e['_id'],
          title: e['title'],
          coverImage:  e['coverImage'],
          author: e['author']
        );
      }).toList();
      return book;
    } else { 
      throw Exception('Failed to load books');
    }
  }

  static Future<BookModel> fetchBookById(String id) async {
    final uri = Uri.parse('${Environment.apiUrl}/v1/books/$id');
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final book = BookModel(
        id: json['_id'],
        title: json['title'],
        coverImage: json['coverImage'],
        chapters: json['chapters'],
        author: json['author']
      );
    return book;
  }
}

  class UserApi {
      static Future<UserModel> fetchUserByEmail(String id) async {
        final uri = Uri.parse('${Environment.apiUrl}/v1/users/$id');
        final response = await http.get(uri);
        final body = response.body;
        final json = jsonDecode(body);
        final picJson = json['picture'];
        PictureModel pictures = PictureModel(
            large: picJson['large'], 
            medium: picJson['medium'], 
            thumbnail: picJson['thumbnail']
          );
        final user = UserModel(
            id: json['_id'],
            name: json['name'],
            email: json['email'],
            password: json['password'],
            pictures: pictures
          );
        return user;
      }
    }