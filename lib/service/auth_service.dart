import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthService {
  static const baseUrl = 'https://faye-trimorphic-discretionarily.ngrok-free.dev/api';

  static Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

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

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', data['data']['token']);
    await prefs.setString('role', data['data']['user']['role']);

    return data['data']['user'];
  }
}
