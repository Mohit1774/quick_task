import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class User {
  final String username;
  final String email;

  // Constructor
  User({required this.username, required this.email});

  // Factory constructor to create User from ParseUser (Parse SDK)
  factory User.fromParseUser(ParseUser parseUser) {
    return User(
      username: parseUser.username ?? '',
      email: parseUser.emailAddress ?? '',
    );
  }
}