# 🔧 Fix: Route Tidak Punya Prefix "api/"

## Problem

Route terdaftar sebagai:
- ❌ `attendance/session` 
- ✅ Seharusnya: `api/attendance/session`

Flutter mencoba akses `http://127.0.0.1:8000/api/attendance/session` tapi Laravel tidak punya prefix `api/`.

---

## Root Cause

File `bootstrap/app.php` tidak mengkonfigurasi prefix `api` untuk routes di `routes/api.php`.

---

## Solution

### Opsi 1: Update bootstrap/app.php (Laravel 11+)

Buka file `bootstrap/app.php`, pastikan ada konfigurasi ini:

```php
<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',  // ADD THIS LINE
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        //
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();
```

**Key point:** Tambahkan `api: __DIR__.'/../routes/api.php',`

### Opsi 2: Update RouteServiceProvider (Laravel 10 dan sebelumnya)

Jika ada file `app/Providers/RouteServiceProvider.php`, pastikan ada:

```php
public function boot(): void
{
    $this->routes(function () {
        Route::middleware('api')
            ->prefix('api')  // INI PENTING!
            ->group(base_path('routes/api.php'));

        Route::middleware('web')
            ->group(base_path('routes/web.php'));
    });
}
```

### Opsi 3: Pindahkan Route ke web.php (Quick Fix)

Jika tidak mau utak-atik config, pindahkan route dari `routes/api.php` ke `routes/web.php`:

**File: routes/web.php**
```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AttendanceController;

// ... route web lainnya ...

// API Routes with manual prefix
Route::prefix('api')->group(function () {
    Route::get('/', function () {
        return response()->json([
            'message' => 'API is running',
            'version' => '1.0'
        ]);
    });

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
        Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);
        Route::get('/attendance/history', [AttendanceController::class, 'historySiswa']);
    });
});
```

---

## After Fix

### Clear Cache
```bash
php artisan route:clear
php artisan config:clear
php artisan cache:clear
```

### Verify Routes
```bash
php artisan route:list
```

Should show:
```
GET|HEAD  api ................................................
POST      api/attendance/session .... AttendanceController@createSesi
POST      api/attendance/scan ....... AttendanceController@scanQR
GET|HEAD  api/attendance/history .... AttendanceController@historySiswa
```

### Test Browser
`http://127.0.0.1:8000/api` → Should return JSON

### Test Flutter
Click "Coba Lagi" → Should work!

---

## Recommended: Opsi 3 (Paling Mudah)

Untuk sekarang, saya sarankan **Opsi 3** karena paling cepat dan tidak perlu utak-atik config Laravel.

1. Buka `routes/web.php`
2. Tambahkan code dari Opsi 3 di atas
3. Hapus semua isi `routes/api.php` (atau comment out)
4. Run `php artisan route:clear`
5. Test!
