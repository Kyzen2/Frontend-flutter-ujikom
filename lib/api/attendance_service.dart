import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendanceService {
  static const baseUrl = "http://192.168.0.129:8000/api";
  final storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, dynamic>> createSession() async {
    final token = await _getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/attendance/session"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> scanQR(String qrCode) async {
    final token = await _getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/attendance/scan"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
      body: {
        "qr_code": qrCode
      },
    );

    return jsonDecode(res.body);
  }
}
