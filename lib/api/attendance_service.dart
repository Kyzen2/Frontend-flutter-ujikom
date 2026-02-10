import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  // Laravel backend via ngrok
  static const baseUrl = "https://faye-trimorphic-discretionarily.ngrok-free.dev/api";

  /// Get authentication token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Create attendance session (Guru generates QR)
  /// 
  /// Parameters:
  /// - jadwalId: ID of the jadwal (schedule) for this session
  /// 
  /// Returns:
  /// - Map with 'status' and 'token_qr' fields
  /// 
  /// Example response from Laravel:
  /// ```json
  /// {
  ///   "status": "success",
  ///   "token_qr": "a1b2c3d4e5f6..."
  /// }
  /// ```
  Future<Map<String, dynamic>> createSession({int jadwalId = 1}) async {
    try {
      final token = await _getToken();

      final res = await http.post(
        Uri.parse("$baseUrl/attendance/session"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "jadwal_id": jadwalId,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      } else {
        String message = 'Failed to create session: ${res.statusCode}';
        try {
          final errorData = jsonDecode(res.body);
          message = errorData['message'] ?? message;
          // If there are validation errors, append them
          if (errorData['errors'] != null) {
            message += ": " + errorData['errors'].toString();
          }
        } catch (_) {}
        
        return {
          'status': 'error',
          'message': message,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  /// Scan QR code for attendance (Murid scans QR)
  /// 
  /// Parameters:
  /// - tokenQr: The QR code token scanned by student
  /// - latitude: Optional GPS latitude
  /// - longitude: Optional GPS longitude
  /// 
  /// Returns:
  /// - Map with 'status' and 'message' fields
  /// 
  /// Example response from Laravel:
  /// ```json
  /// {
  ///   "status": "success",
  ///   "message": "Absen Berhasil"
  /// }
  /// ```
  Future<Map<String, dynamic>> scanQR(
    String tokenQr, {
    double? latitude,
    double? longitude,
  }) async {
    try {
      final token = await _getToken();

      final body = {
        "token_qr": tokenQr,
      };

      // Add GPS coordinates if provided
      if (latitude != null && longitude != null) {
        body['lat_siswa'] = latitude.toString();
        body['long_siswa'] = longitude.toString();
      }

      final res = await http.post(
        Uri.parse("$baseUrl/attendance/scan"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: body,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      } else {
        final errorData = jsonDecode(res.body);
        return {
          'status': 'error',
          'message': errorData['message'] ?? 'Failed to scan QR: ${res.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  /// Get attendance history for current student
  /// 
  /// Returns:
  /// - Map with 'status', 'summary', and 'data' fields
  /// 
  /// Example response from Laravel:
  /// ```json
  /// {
  ///   "status": "success",
  ///   "summary": {
  ///     "total_hadir": 10,
  ///     "total_izin": 2,
  ///     "total_invalid": 0
  ///   },
  ///   "data": [...]
  /// }
  /// ```
  Future<Map<String, dynamic>> getHistory() async {
    try {
      final token = await _getToken();

      final res = await http.get(
        Uri.parse("$baseUrl/attendance/history"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return {
          'status': 'error',
          'message': 'Failed to get history: ${res.statusCode}',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
        'data': [],
      };
    }
  }
}
