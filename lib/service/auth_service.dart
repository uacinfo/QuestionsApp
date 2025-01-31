import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static String sessionTokenString = dotenv.env['SESSION_TOKEN_KEY'] ?? '';
  static Future<String?> getAccessToken() async {
    log('get access token called.');

    final token = await _storage.read(key: sessionTokenString);


    log('get access token found, value : $token');
    return token;
  }
  void deleteAccessToken(){
    _storage.delete(key: sessionTokenString);
  }
}
