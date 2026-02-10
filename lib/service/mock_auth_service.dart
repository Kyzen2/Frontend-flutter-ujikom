import 'package:shared_preferences/shared_preferences.dart';

/// Mock Authentication Service untuk Testing Offline
/// Gunakan ini jika backend API tidak tersedia
class MockAuthService {
  // Database akun dummy
  static final Map<String, Map<String, dynamic>> _accounts = {
    // Akun Guru
    'guru1@sekolah.com': {
      'password': 'guru123',
      'role': 'guru',
      'name': 'Budi Santoso',
      'nip': '198501012010011001',
      'mata_pelajaran': 'Matematika',
    },
    'guru2@sekolah.com': {
      'password': 'guru123',
      'role': 'guru',
      'name': 'Siti Aminah',
      'nip': '198702022011012002',
      'mata_pelajaran': 'Bahasa Indonesia',
    },
    
    // Akun Murid
    'murid1@sekolah.com': {
      'password': 'murid123',
      'role': 'siswa',
      'name': 'Ahmad Rizki',
      'nis': '12345678',
      'kelas': 'XII RPL 1',
    },
    'murid2@sekolah.com': {
      'password': 'murid123',
      'role': 'siswa',
      'name': 'Dewi Lestari',
      'nis': '12345679',
      'kelas': 'XII RPL 1',
    },
    '12345678': {
      'password': 'siswa123',
      'role': 'siswa',
      'name': 'Ahmad Rizki',
      'nis': '12345678',
      'kelas': 'XII RPL 1',
    },
    '12345679': {
      'password': 'siswa123',
      'role': 'siswa',
      'name': 'Dewi Lestari',
      'nis': '12345679',
      'kelas': 'XII RPL 2',
    },
  };

  /// Login dengan akun dummy
  /// Returns user data jika berhasil, null jika gagal
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 500));

    // Cek apakah akun ada
    if (!_accounts.containsKey(email)) {
      return null;
    }

    final account = _accounts[email]!;

    // Cek password
    if (account['password'] != password) {
      return null;
    }

    // Simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString('role', account['role']);
    await prefs.setString('name', account['name']);
    
    if (account['role'] == 'guru') {
      await prefs.setString('nip', account['nip']);
      await prefs.setString('mata_pelajaran', account['mata_pelajaran']);
    } else {
      await prefs.setString('nis', account['nis']);
      await prefs.setString('kelas', account['kelas']);
    }

    // Return user data
    return {
      'role': account['role'],
      'name': account['name'],
      'email': email,
      ...account,
    };
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  /// Get user role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  /// Get user data
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('token'),
      'role': prefs.getString('role'),
      'name': prefs.getString('name'),
      'nis': prefs.getString('nis'),
      'nip': prefs.getString('nip'),
      'kelas': prefs.getString('kelas'),
      'mata_pelajaran': prefs.getString('mata_pelajaran'),
    };
  }
}
