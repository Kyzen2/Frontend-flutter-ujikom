# 🚀 Quick Start Guide - QR Attendance System

## Langkah 1: Jalankan Laravel Backend

Buka terminal di folder backend Laravel Anda, lalu jalankan:

```bash
php artisan serve
```

✅ Server akan berjalan di: `http://127.0.0.1:8000`

**Catatan:** Jangan gunakan `--host` karena bisa menyebabkan error. Cukup `php artisan serve` saja.

---

## Langkah 2: Pastikan Database Siap

Jika belum migrate database:

```bash
php artisan migrate:fresh --seed
```

---

## Langkah 3: Pastikan Route API Terdaftar

Buka file `routes/api.php` di Laravel, pastikan ada:

```php
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
    Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);
    Route::get('/attendance/history', [AttendanceController::class, 'historySiswa']);
});
```

---

## Langkah 4: Jalankan Flutter App

Di terminal Flutter:

```bash
flutter run
```

---

## Langkah 5: Test Login

**Login sebagai Guru:**
- Email: `guru1@sekolah.com`
- Password: `guru123`

**Login sebagai Murid:**
- Email: `murid1@sekolah.com`
- Password: `murid123`

---

## Langkah 6: Test Generate QR (Guru)

1. Login sebagai guru
2. Klik tombol "Generate QR"
3. QR code akan muncul

**Jika error "Network error":**
- Pastikan Laravel server masih running
- Cek di browser: `http://127.0.0.1:8000/api` (harus ada response)

---

## Langkah 7: Test Scan QR (Murid)

1. Login sebagai murid
2. Klik tombol "Scan QR"
3. Scan QR code dari layar guru
4. Akan muncul "Absensi berhasil!"

---

## Troubleshooting

### ❌ Error: "Failed to listen on 192.168.0.129:8000"

**Solusi:** Jangan gunakan `--host`, cukup:
```bash
php artisan serve
```

### ❌ Error: "Network error" di Flutter

**Solusi:**
1. Pastikan Laravel server running
2. Test di browser: `http://127.0.0.1:8000`
3. Pastikan URL di Flutter sudah benar (sudah saya update ke `127.0.0.1`)

### ❌ Error: "Unauthenticated"

**Solusi:**
- Anda sedang pakai MockAuthService (offline mode)
- Untuk connect ke backend real, perlu switch ke AuthService
- Tapi untuk testing QR, MockAuthService sudah cukup

### ❌ QR Scanner tidak buka kamera

**Solusi:**
- Test di physical device (bukan emulator)
- Grant camera permission
- Pastikan package `mobile_scanner` sudah terinstall

---

## Verifikasi Database

Setelah scan QR, cek database:

```sql
-- Cek sesi yang dibuat guru
SELECT * FROM sesi_presensi ORDER BY id DESC LIMIT 5;

-- Cek absensi yang di-scan murid
SELECT * FROM absensi ORDER BY id DESC LIMIT 5;
```

---

## URL Configuration

**Backend URL saat ini:** `http://127.0.0.1:8000/api`

Sudah saya update di file:
- `lib/api/attendance_service.dart`

**Jika backend di server lain:**
Edit file tersebut dan ganti `baseUrl`.

---

## Next Steps

✅ Backend running  
✅ Flutter running  
✅ Login works  
⬜ Test Generate QR  
⬜ Test Scan QR  
⬜ Check database  

---

**Need Help?** Check:
- [TESTING_GUIDE.md](file:///c:/Users/ACER/OneDrive/Turky%20Projek/ujikomaplikasi/TESTING_GUIDE.md) - Detailed testing
- [API_DOCUMENTATION.md](file:///c:/Users/ACER/OneDrive/Turky%20Projek/ujikomaplikasi/API_DOCUMENTATION.md) - API reference
