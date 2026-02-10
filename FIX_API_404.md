# 🔧 Fix: API Route 404 Error

## Problem

- Flutter error: "Failed to create session: 404"
- Browser shows: `127.0.0.1:8000/api` → "404 NOT FOUND"

## Root Cause

**Route API belum didaftarkan** di file `routes/api.php` Laravel Anda.

---

## Solution

### Step 1: Buka File routes/api.php

Path: `c:\laragon\www\backenUjikom\routes\api.php`

### Step 2: Tambahkan Route Berikut

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AttendanceController;

// Test route (optional, untuk cek API berjalan)
Route::get('/', function () {
    return response()->json([
        'message' => 'API is running',
        'version' => '1.0'
    ]);
});

// Attendance routes (REQUIRED)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
    Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);
    Route::get('/attendance/history', [AttendanceController::class, 'historySiswa']);
});

// Jika ada route lain, tambahkan di sini
```

### Step 3: Verify

Setelah save file, test di browser:

**Test 1:** `http://127.0.0.1:8000/api`

Expected response:
```json
{
  "message": "API is running",
  "version": "1.0"
}
```

**Test 2:** `http://127.0.0.1:8000/api/attendance/session` (akan error 401 karena butuh auth, tapi bukan 404)

---

## Alternative: Jika Masih 404

### Check 1: Pastikan Laravel Server Running

```bash
php artisan serve
```

Harus ada output:
```
Starting Laravel development server: http://127.0.0.1:8000
```

### Check 2: Clear Route Cache

```bash
php artisan route:clear
php artisan config:clear
php artisan cache:clear
```

### Check 3: Verify Routes Registered

```bash
php artisan route:list
```

Harus ada output seperti:
```
POST   api/attendance/session .... AttendanceController@createSesi
POST   api/attendance/scan ....... AttendanceController@scanQR
GET    api/attendance/history .... AttendanceController@historySiswa
```

---

## Testing After Fix

### Test 1: Browser Test
1. Buka: `http://127.0.0.1:8000/api`
2. Should see: `{"message": "API is running", "version": "1.0"}`

### Test 2: Flutter Test
1. Klik "Coba Lagi" di Flutter app
2. Should generate QR code (jika sudah login dengan backend real)

---

## Important Notes

### About Authentication

Route attendance menggunakan `auth:sanctum` middleware, jadi:

1. **MockAuthService (current)** → Tidak akan bisa connect ke backend karena token fake
2. **Real AuthService** → Perlu login via backend untuk dapat token valid

### For Testing with Backend

Anda perlu:
1. ✅ Register routes (langkah di atas)
2. ✅ Login via backend API (bukan MockAuthService)
3. ✅ Token valid dari backend

### Quick Test Without Auth (Optional)

Jika mau test tanpa auth dulu, bisa comment out middleware:

```php
// Temporary untuk testing
Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);

// Nanti kembalikan ke:
// Route::middleware('auth:sanctum')->group(function () {
//     Route::post('/attendance/session', ...);
// });
```

---

## Next Steps

1. [ ] Add routes to `routes/api.php`
2. [ ] Clear cache: `php artisan route:clear`
3. [ ] Test browser: `http://127.0.0.1:8000/api`
4. [ ] Test Flutter: Click "Coba Lagi"
5. [ ] If still error, check Laravel logs
