# 📡 API Documentation - QR Attendance System

## Base URL
```
http://192.168.0.129:8000/api
```

> **Note**: Update this URL in `lib/api/attendance_service.dart` if your backend is hosted elsewhere.

---

## Authentication

All endpoints require Bearer token authentication.

**Header:**
```
Authorization: Bearer {token}
Accept: application/json
```

Token is obtained from login and stored in `SharedPreferences`.

---

## Endpoints

### 1. Create Attendance Session (Generate QR)

**Endpoint:** `POST /attendance/session`

**Used by:** Guru (Teacher)

**Purpose:** Generate QR code token for attendance session

**Request Body:**
```json
{
  "jadwal_id": 1
}
```

**Success Response (200):**
```json
{
  "status": "success",
  "token_qr": "a1b2c3d4e5f6789..."
}
```

**Laravel Controller:**
```php
public function createSesi(Request $request)
{
    $token = bin2hex(random_bytes(16));
    $sesi = sesi::create([
        'jadwal_id' => $request->jadwal_id,
        'tanggal' => now()->toDateString(),
        'token_qr' => $token
    ]);
    return response()->json(['status' => 'success', 'token_qr' => $token]);
}
```

**Database Impact:**
- Inserts new record in `sesi_presensi` table
- Fields: `jadwal_id`, `tanggal`, `token_qr`

---

### 2. Scan QR Code (Submit Attendance)

**Endpoint:** `POST /attendance/scan`

**Used by:** Murid (Student)

**Purpose:** Submit attendance by scanning QR code

**Request Body:**
```json
{
  "token_qr": "a1b2c3d4e5f6789...",
  "lat_siswa": "-6.200000",    // Optional
  "long_siswa": "106.816666"   // Optional
}
```

**Success Response (200):**
```json
{
  "status": "success",
  "message": "Absen Berhasil"
}
```

**Error Response (403):**
```json
{
  "status": "error",
  "message": "Hanya siswa yang dapat melakukan absensi!"
}
```

**Laravel Controller:**
```php
public function scanQR(Request $request)
{
    $user = Auth::user();
    
    if ($user->role !== 'siswa') {
        return response()->json([
            'status' => 'error',
            'message' => 'Hanya siswa yang dapat melakukan absensi!'
        ], 403);
    }

    $sesi = sesi::where('token_qr', $request->token_qr)->firstOrFail();

    Absensi::create([
        'sesi_id' => $sesi->id,
        'siswa_id' => $user->siswa->id,
        'waktu_scan' => now(),
        'status' => 'hadir',
    ]);

    return response()->json([
        'status' => 'success',
        'message' => 'Absen Berhasil',
    ]);
}
```

**Database Impact:**
- Inserts new record in `absensi` table
- Fields: `sesi_id`, `siswa_id`, `waktu_scan`, `status`

---

### 3. Get Attendance History

**Endpoint:** `GET /attendance/history`

**Used by:** Murid (Student)

**Purpose:** Get attendance history for logged-in student

**Request:** No body required

**Success Response (200):**
```json
{
  "status": "success",
  "summary": {
    "total_hadir": 10,
    "total_izin": 2,
    "total_invalid": 0
  },
  "data": [
    {
      "id": 1,
      "sesi_id": 5,
      "siswa_id": 3,
      "waktu_scan": "2026-02-10 10:30:00",
      "status": "hadir",
      "is_valid": true,
      "sesi": {
        "jadwal": {
          "mapel": {
            "nama_mapel": "Matematika"
          }
        }
      }
    }
  ]
}
```

**Laravel Controller:**
```php
public function historySiswa()
{
    $user = Auth::user();

    $history = Absensi::with(['sesi.jadwal.mapel'])
        ->where('siswa_id', $user->siswa->id)
        ->orderBy('waktu_scan', 'desc')
        ->get();

    $summary = [
        'total_hadir' => $history->where('status', 'hadir')->count(),
        'total_izin'  => $history->where('status', 'izin')->count(),
        'total_invalid' => $history->where('is_valid', false)->count(),
    ];

    return response()->json([
        'status' => 'success',
        'summary' => $summary,
        'data' => $history
    ]);
}
```

---

## Error Handling

### Common Error Responses

**401 Unauthorized:**
```json
{
  "message": "Unauthenticated."
}
```

**404 Not Found:**
```json
{
  "message": "Model not found"
}
```

**500 Server Error:**
```json
{
  "message": "Server Error",
  "exception": "..."
}
```

---

## Flutter Integration

### AttendanceService Usage

**Generate QR (Guru):**
```dart
final service = AttendanceService();
final result = await service.createSession(jadwalId: 1);

if (result['status'] == 'success') {
  String qrToken = result['token_qr'];
  // Display QR code with qrToken
}
```

**Scan QR (Murid):**
```dart
final service = AttendanceService();
final result = await service.scanQR(scannedToken);

if (result['status'] == 'success') {
  // Show success message
  print(result['message']);
}
```

**Get History (Murid):**
```dart
final service = AttendanceService();
final result = await service.getHistory();

if (result['status'] == 'success') {
  var summary = result['summary'];
  var data = result['data'];
  // Display history
}
```

---

## Database Schema Reference

### sesi_presensi
| Field | Type | Description |
|-------|------|-------------|
| id | INT (PK) | Sesi ID |
| jadwal_id | INT | FK to jadwal |
| tanggal | DATE | Session date |
| token_qr | VARCHAR | QR code token |

### absensi
| Field | Type | Description |
|-------|------|-------------|
| id | BIGINT (PK) | Attendance ID |
| sesi_id | INT | FK to sesi_presensi |
| siswa_id | INT | FK to siswa |
| waktu_scan | TIMESTAMP | Scan time |
| status | ENUM | hadir/sakit/izin/alpa |
| is_valid | BOOLEAN | GPS validation result |
| lat_siswa | DOUBLE | Student latitude |
| long_siswa | DOUBLE | Student longitude |

---

## Testing with Postman/cURL

### Test Create Session
```bash
curl -X POST http://192.168.0.129:8000/api/attendance/session \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{"jadwal_id": 1}'
```

### Test Scan QR
```bash
curl -X POST http://192.168.0.129:8000/api/attendance/scan \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json" \
  -d "token_qr=YOUR_QR_TOKEN"
```

### Test Get History
```bash
curl -X GET http://192.168.0.129:8000/api/attendance/history \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

**Last Updated:** 2026-02-10  
**API Version:** 1.0
