import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform; // Only for non-web
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthService {
  static const baseUrl = 'https://faye-trimorphic-discretionarily.ngrok-free.dev/api';

  static Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      final web = await deviceInfo.webBrowserInfo;
      return web.userAgent ?? 'web-browser';
    }

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return android.id;
    }

    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? 'ios';
    }

    return 'unknown';
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final deviceId = await _getDeviceId();

    print('📝 DEBUG LOGIN: Sending request to $baseUrl/login');
    print('📦 DEBUG LOGIN: Body: email=$email, device_id=$deviceId');

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
        'device_id': deviceId,
      },
    );

    print('📡 DEBUG LOGIN: Status Code: ${response.statusCode}');
    print('📄 DEBUG LOGIN: Response Body: ${response.body}');

    if (response.statusCode != 200) {
      print('❌ DEBUG LOGIN: Login Failed with status ${response.statusCode}');
      return null;
    }

    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', data['data']['token']);
    await prefs.setString('role', data['data']['user']['role']);

    return data['data']['user'];
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
  }
}
