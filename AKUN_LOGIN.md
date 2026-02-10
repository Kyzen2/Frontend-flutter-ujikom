# 🔐 Akun Login Testing - EduAttend

Berikut adalah akun-akun yang dapat digunakan untuk testing aplikasi EduAttend:

---

## 👨‍🏫 Akun Guru (Teacher)

### Guru 1
- **Email/NIS**: `guru1@sekolah.com`
- **Password**: `guru123`
- **Role**: Guru
- **Akses**: GuruView Dashboard
- **Fitur**:
  - Generate QR Code untuk absensi
  - Lihat jadwal mengajar
  - Kelola data siswa
  - Lihat history mengajar

### Guru 2
- **Email/NIS**: `guru2@sekolah.com`
- **Password**: `guru123`
- **Role**: Guru
- **Akses**: GuruView Dashboard

---

## 👨‍🎓 Akun Murid (Student)

### Murid 1
- **Email/NIS**: `murid1@sekolah.com`
- **Password**: `murid123`
- **Role**: Siswa
- **Akses**: MuridView Dashboard
- **Fitur**:
  - Scan QR Code untuk absensi
  - Lihat jadwal pelajaran
  - Lihat history kehadiran
  - Lihat profil

### Murid 2
- **Email/NIS**: `murid2@sekolah.com`
- **Password**: `murid123`
- **Role**: Siswa
- **Akses**: MuridView Dashboard

### Murid 3
- **Email/NIS**: `12345678`
- **Password**: `siswa123`
- **Role**: Siswa
- **Akses**: MuridView Dashboard

---

## 📝 Catatan Penting

1. **Backend API**: Aplikasi ini menggunakan backend API di:
   ```
   https://faye-trimorphic-discretionarily.ngrok-free.dev/api
   ```

2. **Login Flow**:
   - Masukkan NIS/Email di field pertama
   - Masukkan password di field kedua
   - Klik tombol "Login"
   - Sistem akan otomatis redirect ke:
     - **GuruView** jika role = "guru"
     - **MuridView** jika role = "siswa"

3. **Testing**:
   - Akun-akun di atas adalah akun dummy untuk testing
   - Pastikan backend API sudah running
   - Pastikan device memiliki koneksi internet

4. **Troubleshooting**:
   - Jika login gagal, cek koneksi internet
   - Pastikan backend API masih aktif
   - Cek console untuk error messages

---

## 🔄 Cara Menggunakan

### Login sebagai Guru:
```
1. Buka aplikasi
2. Masukkan: guru1@sekolah.com
3. Password: guru123
4. Klik Login
5. Akan masuk ke GuruView Dashboard
```

### Login sebagai Murid:
```
1. Buka aplikasi
2. Masukkan: murid1@sekolah.com
3. Password: murid123
4. Klik Login
5. Akan masuk ke MuridView Dashboard
```

---

## ⚠️ Disclaimer

Akun-akun ini hanya untuk keperluan **TESTING** dan **DEVELOPMENT**. 
Jangan gunakan untuk production environment!

---

**Last Updated**: 2026-02-10
**App Version**: EduAttend V2.4
