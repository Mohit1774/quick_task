

import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserService {

  final Logger _logger = Logger();

  /// Retrieve the current user ID (objectId)
  Future<String?> getCurrentUserId() async {
    try {
    // Retrieve the currently logged-in user
    final ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    
    if (currentUser != null) {
      // Return the user ID (objectId)
        return currentUser.objectId;
      } else {
        _logger.e('No user is logged in.');
        return null;
      }
    } catch (e) {
      _logger.e('Error retrieving user ID: $e');
      return null;
    }
  }
}
