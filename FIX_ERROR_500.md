# 🔧 Debugging Error 500

## Current Status

- ✅ API route registered: `api/attendance/session`
- ✅ CSRF disabled for API
- ❌ Error 500: Internal Server Error

## Error 500 = Backend Code Error

Error 500 berarti ada masalah di kode Laravel (AttendanceController).

---

## Step 1: Check Laravel Logs

Buka file: `c:\laragon\www\backenUjikom\storage\logs\laravel.log`

Cari error terbaru (paling bawah file). Biasanya ada pesan seperti:
- `Class not found`
- `Call to undefined method`
- `Column not found`
- `Undefined variable`

---

## Step 2: Kemungkinan Masalah di AttendanceController

### Masalah 1: Model `sesi` tidak ada

Di `AttendanceController.php`, ada code:
```php
$sesi = sesi::create([...]);
```

**Problem:** Model `sesi` mungkin tidak ada atau nama class salah.

**Fix:** Pastikan ada file `app/Models/Sesi.php` atau `app/Models/SesiPresensi.php`

Atau update controller:
```php
use App\Models\SesiPresensi; // atau Sesi

public function createSesi(Request $request)
{
    $token = bin2hex(random_bytes(16));
    $sesi = SesiPresensi::create([  // Ganti sesi jadi SesiPresensi
        'jadwal_id' => $request->jadwal_id ?? 1,
        'tanggal' => now()->toDateString(),
        'token_qr' => $token
    ]);
    return response()->json(['status' => 'success', 'token_qr' => $token]);
}
```

### Masalah 2: Fillable tidak diset

Model `SesiPresensi` harus punya `$fillable`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SesiPresensi extends Model
{
    protected $table = 'sesi_presensi';
    
    protected $fillable = [
        'jadwal_id',
        'tanggal',
        'token_qr'
    ];
}
```

### Masalah 3: Table name salah

Jika model bernama `Sesi` tapi table bernama `sesi_presensi`, perlu set:

```php
protected $table = 'sesi_presensi';
```

---

## Quick Fix (Tanpa Model)

Jika mau cepat, bisa pakai DB query langsung:

```php
use Illuminate\Support\Facades\DB;

public function createSesi(Request $request)
{
    $token = bin2hex(random_bytes(16));
    
    DB::table('sesi_presensi')->insert([
        'jadwal_id' => $request->jadwal_id ?? 1,
        'tanggal' => now()->toDateString(),
        'token_qr' => $token,
        'created_at' => now(),
        'updated_at' => now(),
    ]);
    
    return response()->json(['status' => 'success', 'token_qr' => $token]);
}
```

---

## Action Items

1. **Check Laravel log** di `storage/logs/laravel.log`
2. **Share error message** dengan saya
3. Atau **coba Quick Fix** di atas
4. Test lagi!
