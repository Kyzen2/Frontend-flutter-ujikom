# 🔧 Fix: Database Migration Error

## Error yang Terjadi

```
SQLSTATE[42S22]: Column not found: 1054 Unknown column 'email_verified_at' in 'field list'
```

## Penyebab

Laravel's default `DatabaseSeeder` mencoba membuat user test dengan kolom `email_verified_at`, tapi tabel `users` Anda tidak punya kolom tersebut (karena menggunakan custom schema).

## Solusi

### Opsi 1: Update Migration Users (Recommended)

Buka file `database/migrations/0001_01_01_000000_create_users_table.php`

Pastikan ada kolom `email_verified_at`:

```php
Schema::create('users', function (Blueprint $table) {
    $table->id();
    $table->string('serial_number')->unique(); // NISN/NIP
    $table->string('password');
    $table->enum('role', ['admin', 'guru', 'siswa']);
    $table->timestamp('email_verified_at')->nullable(); // ADD THIS LINE
    $table->rememberToken();
    $table->timestamps();
});
```

### Opsi 2: Update DatabaseSeeder (Easier)

Buka file `database/seeders/DatabaseSeeder.php`

**Hapus atau comment out** bagian yang membuat test user:

```php
public function run(): void
{
    // Comment out atau hapus ini:
    // User::factory()->create([
    //     'name' => 'Test User',
    //     'email' => 'test@example.com',
    // ]);

    // Panggil seeder lain yang Anda punya
    $this->call([
        // TahunAjaranSeeder::class,
        // GuruSeeder::class,
        // SiswaSeeder::class,
        // dll...
    ]);
}
```

### Opsi 3: Skip Seeding (Quick Fix)

Jika tidak butuh data dummy, cukup migrate tanpa seed:

```bash
php artisan migrate:fresh
```

## Langkah-langkah

1. **Pilih salah satu opsi di atas**
2. **Jalankan ulang migration:**
   ```bash
   php artisan migrate:fresh --seed
   ```
   atau tanpa seed:
   ```bash
   php artisan migrate:fresh
   ```

3. **Jika berhasil, jalankan server:**
   ```bash
   php artisan serve
   ```

## Catatan Penting

Untuk testing QR attendance, Anda perlu data:
- Minimal 1 guru di tabel `guru` dan `users`
- Minimal 1 siswa di tabel `siswa` dan `users`
- Minimal 1 jadwal di tabel `jadwal`

**Jika tidak ada seeder**, Anda bisa:
1. Insert manual via phpMyAdmin/MySQL
2. Atau buat seeder sendiri
3. Atau gunakan MockAuthService (sudah aktif) untuk testing tanpa backend

## Testing Tanpa Backend (Recommended untuk Sekarang)

Karena ada masalah dengan seeding, Anda bisa test dulu dengan MockAuthService:

1. **Skip database setup untuk sekarang**
2. **Langsung test Flutter app:**
   ```bash
   flutter run
   ```
3. **Login dengan akun mock:**
   - Guru: `guru1@sekolah.com` / `guru123`
   - Murid: `murid1@sekolah.com` / `murid123`

4. **Test UI QR generation dan scanning** (akan error saat connect ke backend, tapi UI bisa dilihat)

## Next Steps

Setelah fix migration:
- [ ] Fix DatabaseSeeder atau migration
- [ ] Run `php artisan migrate:fresh --seed`
- [ ] Verify data di database
- [ ] Start Laravel server
- [ ] Test full integration
