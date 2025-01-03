import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'API_URL not found';
  }

  static String get comicUrl {
    return dotenv.env['COMIC_URL'] ?? 'COMIC_UR not found';
  }
}