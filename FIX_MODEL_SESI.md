# 🔧 Fix untuk Model Sesi

Ganti isi file `app/Models/sesi.php` (atau `sesipresensi.php`) dengan:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class sesi extends Model
{
    use HasFactory;

    protected $table = 'sesi_presensi';  // FIX: Ganti 'Sesi' jadi 'sesi_presensi'
    protected $fillable = ['jadwal_id', 'tanggal', 'token_qr'];

    public function jadwal()
    {
        return $this->belongsTo(Jadwal::class, 'jadwal_id');
    }
    
    public function absensi()
    {
        return $this->hasMany(Absensi::class, 'sesi_id');
    }
}
```

**Yang diubah:**
- `protected $table = 'Sesi';` → `protected $table = 'sesi_presensi';`

**Kenapa error:**
Laravel mencari table bernama `Sesi` tapi yang ada di database adalah `sesi_presensi`.

**Setelah fix:**
1. Save file
2. Klik "Coba Lagi" di Flutter app
3. QR code seharusnya muncul! 🎉
