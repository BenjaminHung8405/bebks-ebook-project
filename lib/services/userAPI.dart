import 'package:http/http.dart' as http;
import 'package:bebks_ebooks/models/environment.dart';
class UserApi {
  static Future<dynamic> fetchUsers() async {
    var url = Environment.apiUrl;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
  }
}