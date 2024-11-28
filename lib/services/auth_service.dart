import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  static const String baseUrl = 'https://parseapi.back4app.com';
  // User Sign-Up
  static Future<ParseUser?> registerUser(String email, String password) async {
    final user = ParseUser(email, password, email); // ParseUser(email, password, email) -> where third parameter is the username
    final response = await user.signUp();
    
    if (response.success) {
      return user;
    } else {
      return null;
    }
  }

  // User Login
  // static Future<String?> loginUser(String username, String password) async {
  //   final url = Uri.parse('$baseUrl/login');
  //   final headers = {
  //     'X-Parse-Application-Id': dotenv.env['APPLICATION_ID']!,
  //     'X-Parse-REST-API-Key': dotenv.env['CLIENT_KEY']!,
  //     'Content-Type': 'application/json',
  //   };
  //   final body = jsonEncode({
  //     'username': username,
  //     'password': password,
  //   });

  //   final response = await http.post(url, headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['sessionToken']; // Return the session token if login succeeds
  //   } else {
  //     return null; // Return null if login fails
  //   }
  // }

  Future<ParseUser?> loginUser(String email, String password) async {
    final user = ParseUser(email, password, null);
    final response = await user.login();

    if (response.success) {
      return response.result;
    }
    return null;
  }
}
