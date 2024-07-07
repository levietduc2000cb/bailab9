import 'dart:convert';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import 'login_request.dart';
import 'login_response.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<List<Post>> getAllPostByUserId(
      {required int id, required int skip, required int limit}) async {
    final baseUrl = Uri.parse('${Constants.getAllPostByUserId}$id');

    final url = baseUrl.replace(queryParameters: {
      'skip': skip.toString(),
      'limit': limit.toString(),
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return _parsePosts(utf8.decode(response.bodyBytes));
    }

    throw Exception('Status code: ${response.statusCode}');
  }

  static List<Post> _parsePosts(String response) {
    final jsonObject = jsonDecode(response);
    final List<dynamic> jsonResponse = jsonObject['posts'];
    return jsonResponse.map<Post>((json) => Post.fromJson(json)).toList();
  }

  static Future<LoginResponse?> login(LoginRequest loginRequest) async {
    final baseUrl = Uri.parse(Constants.login);
    final body = {
      "username": loginRequest.username,
      "password": loginRequest.password
    };

    try {
      final response = await http.post(baseUrl, body: body);

      // Success
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return LoginResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  static Future<User?> getCurrentAuthUser(String token) async {
    final baseUrl = Uri.parse(Constants.getCurrentAuthUser);
    final header = <String, String>{
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(baseUrl, headers: header);

      // Success
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
