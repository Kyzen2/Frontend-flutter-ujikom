# 🔧 Fix: Error 419 CSRF Token Mismatch

## Problem

Error "Failed to create session: 419" terjadi karena route API memerlukan CSRF token protection (karena ada di `web.php`), tapi Flutter tidak mengirim CSRF token.

---

## Solution: Disable CSRF untuk API Routes

### Opsi 1: Exclude API Routes dari CSRF (Recommended)

Buka file `app/Http/Middleware/VerifyCsrfToken.php`

Tambahkan API routes ke `$except`:

```php
<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;

class VerifyCsrfToken extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array<int, string>
     */
    protected $except = [
        'api/*',  // ADD THIS LINE - Exclude all API routes from CSRF
    ];
}
```

### Opsi 2: Pindahkan ke routes/api.php (Better)

Lebih baik pindahkan route API kembali ke `routes/api.php` karena file tersebut otomatis tidak pakai CSRF.

**File: routes/api.php** (uncomment semua)
```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AttendanceController;

Route::get('/', function () {
    return response()->json([
        'message' => 'API is running',
        'version' => '1.0'
    ]);
});

// No middleware auth untuk testing
Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);
Route::get('/attendance/history', [AttendanceController::class, 'historySiswa']);
```

**File: routes/web.php** (hapus bagian API)
```php
// Hapus atau comment out bagian ini:
// Route::prefix('api')->group(function () {
//     ...
// });
```

**Kemudian:**
```bash
php artisan route:clear
php artisan config:clear
```

---

## After Fix

1. Clear cache: `php artisan route:clear`
2. Test browser: `http://127.0.0.1:8000/api` ✅
3. Test Flutter: Klik "Coba Lagi" ✅
4. Should generate QR code successfully! 🎉

---

## Why This Happens

- Routes di `web.php` → Pakai CSRF protection
- Routes di `api.php` → Tidak pakai CSRF protection
- Flutter app → Tidak bisa kirim CSRF token

**Solution:** Exclude API dari CSRF atau pindah ke `api.php`
