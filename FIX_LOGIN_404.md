# 🔧 Fix: API Login Route 404 Error

## Problem

- Flutter error: "Login gagal: 404"
- Terminal log: `The route api/login could not be found.`

## Root Cause

Anda sudah menambahkan route untuk absensi di `routes/api.php`, tapi **route untuk login belum didaftarkan** di file tersebut. Karena Flutter sekarang menggunakan `AuthService` (bukan Mock lagi), dia butuh endpoint login yang asli di backend.

---

## Solusi

### Step 1: Tambahkan Route Login ke routes/api.php

Buka file `c:\laragon\www\backenUjikom\routes\api.php` dan tambahkan route login di **LUAR** group middleware auth:

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\AuthController; // Tambahkan ini

// 1. Route Login (TIDAK BOLEH pakai middleware auth)
Route::post('/login', [AuthController::class, 'login']);

// 2. Route yang butuh authentication
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
    Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);
    Route::get('/attendance/history', [AttendanceController::class, 'historySiswa']);
});
```

### Step 2: Buat AuthController (Jika belum ada)

Jika Anda belum punya `AuthController`, buat file baru di `app/Http/Controllers/AuthController.php`:

```php
<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required',
            'password' => 'required',
            'device_id' => 'required',
        ]);

        // Cari user berdasarkan email ATAU serial_number (NISN/NIP)
        $user = User::where('email', $request->email)
                    ->orWhere('serial_number', $request->email) 
                    ->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Kombinasi Email/NIS dan Password salah bro.'
            ], 401);
        }

        // Generate Token Sanctum
        $token = $user->createToken($request->device_id)->plainTextToken;

        return response()->json([
            'status' => 'success',
            'data' => [
                'token' => $token,
                'user' => $user
            ]
        ]);
    }
}
```

### Step 3: Clear Cache

Jalankan ini di terminal folder Laravel:
```bash
php artisan route:clear
php artisan config:clear
```

---

## Verify

1. Test dengan Postman atau Browser: `POST http://127.0.0.1:8000/api/login`
2. **Buka Flutter app**, coba login lagi pake `murid1@sekolah.com` / `murid123`.
3. Kalau status code **200 OK**, berarti beres!

---

## Kenapa Guru (Web) Bisa Login?
Karena Guru di Web pakai session bawaan Laravel (bukan token API). Flutter butuh Token API (Sanctum), makanya dia butuh route khusus di `api.php`.
