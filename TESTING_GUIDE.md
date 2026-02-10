# 🧪 Testing Guide - QR Attendance System

## Prerequisites

### Backend Setup
1. **Laravel server must be running:**
   ```bash
   cd /path/to/backend_ujikom
   php artisan serve --host=192.168.0.129 --port=8000
   ```

2. **Database must be migrated and seeded:**
   ```bash
   php artisan migrate:fresh --seed
   ```

3. **Ensure these routes exist in `routes/api.php`:**
   ```php
   Route::middleware('auth:sanctum')->group(function () {
       Route::post('/attendance/session', [AttendanceController::class, 'createSesi']);
       Route::post('/attendance/scan', [AttendanceController::class, 'scanQR']);
       Route::get('/attendance/history', [AttendanceController::class, 'historySiswa']);
   });
   ```

### Frontend Setup
1. **Flutter app using MockAuthService** (for offline login)
2. **Backend URL configured** in `lib/api/attendance_service.dart`

---

## Test Scenarios

### ✅ Test 1: Login Flow

**Objective:** Verify login works for both guru and murid

**Steps:**
1. Run Flutter app: `flutter run`
2. Login as guru: `guru1@sekolah.com` / `guru123`
3. **Expected:** Redirect to GuruView Dashboard
4. Logout
5. Login as murid: `murid1@sekolah.com` / `murid123`
6. **Expected:** Redirect to MuridView Dashboard

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

---

### ✅ Test 2: Generate QR Code (Guru)

**Objective:** Guru can generate QR code and session is saved to database

**Steps:**
1. Login as guru
2. Navigate to "Generate QR" page
3. **Expected:** 
   - Loading indicator appears
   - QR code is displayed
   - Session info shows current date/time
   - No error messages

4. **Verify in database:**
   ```sql
   SELECT * FROM sesi_presensi ORDER BY id DESC LIMIT 1;
   ```
   - Should have new record with `token_qr` not null
   - `tanggal` should be today's date

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

### ✅ Test 3: Scan QR Code (Murid)

**Objective:** Murid can scan QR and attendance is saved to database

**Prerequisites:** QR code generated from Test 2

**Steps:**
1. Login as murid
2. Navigate to "Scan QR" page
3. Scan the QR code (or manually input token for testing)
4. **Expected:**
   - "Absensi berhasil!" message appears
   - Green snackbar shows success
   - Returns to dashboard

5. **Verify in database:**
   ```sql
   SELECT * FROM absensi ORDER BY id DESC LIMIT 1;
   ```
   - Should have new record
   - `sesi_id` matches the session from Test 2
   - `siswa_id` matches logged-in student
   - `status` = 'hadir'
   - `waktu_scan` is current timestamp

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

### ✅ Test 4: Error Handling - Backend Offline

**Objective:** App handles backend errors gracefully

**Steps:**
1. Stop Laravel server
2. Try to generate QR code
3. **Expected:**
   - Error message displayed
   - "Coba Lagi" button appears
   - No app crash

4. Try to scan QR code
5. **Expected:**
   - Error message displayed
   - No app crash

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

### ✅ Test 5: Error Handling - Invalid QR Token

**Objective:** App handles invalid QR tokens properly

**Steps:**
1. Ensure backend is running
2. Login as murid
3. Scan a fake/invalid QR token (e.g., "INVALID_TOKEN_123")
4. **Expected:**
   - Error message: "Token tidak valid" or similar
   - Red snackbar shows error
   - Can retry scanning

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

### ✅ Test 6: Duplicate Scan

**Objective:** Verify behavior when scanning same QR twice

**Steps:**
1. Login as murid
2. Scan QR code successfully
3. Scan the same QR code again
4. **Expected:**
   - Either: Success (allows multiple scans)
   - Or: Error (if backend prevents duplicates)

5. **Verify in database:**
   ```sql
   SELECT * FROM absensi WHERE sesi_id = ? AND siswa_id = ?;
   ```
   - Check if multiple records exist

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

### ✅ Test 7: Refresh QR Code

**Objective:** Guru can refresh/regenerate QR code

**Steps:**
1. Login as guru
2. Generate QR code
3. Click refresh button in app bar
4. **Expected:**
   - New QR code is generated
   - New session created in database
   - Different token_qr value

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

### ✅ Test 8: Camera Controls (Scan QR)

**Objective:** Camera controls work properly

**Steps:**
1. Login as murid
2. Open scan QR page
3. Test flash toggle button
4. **Expected:** Flash turns on/off

5. Test camera switch button
6. **Expected:** Camera switches (if multiple cameras available)

**Status:** ⬜ Not Tested | ✅ Passed | ❌ Failed

**Notes:**
_____________________

---

## Integration Testing Checklist

- [ ] Backend API is accessible from Flutter app
- [ ] Authentication token is properly sent in requests
- [ ] QR generation creates database record
- [ ] QR scanning creates attendance record
- [ ] Error messages are user-friendly
- [ ] Loading states work correctly
- [ ] Success feedback is clear
- [ ] Camera permissions granted (for QR scan)

---

## Known Issues / Limitations

1. **Hardcoded jadwal_id:** Currently set to `1` in generate QR. Need to add jadwal selection UI.

2. **GPS Validation:** Commented out in backend. Not implemented in frontend yet.

3. **Device ID Validation:** Not implemented yet.

4. **Backend URL:** Hardcoded to `192.168.0.129:8000`. Need to update for production.

5. **Mock Auth vs Real Auth:** Currently using MockAuthService. Need to switch to real AuthService for production.

---

## Troubleshooting

### Issue: "Network error" when generating QR

**Solutions:**
- Check if Laravel server is running
- Verify backend URL in `attendance_service.dart`
- Check if device can reach backend (same network for local IP)
- Check Laravel logs: `tail -f storage/logs/laravel.log`

### Issue: "Unauthenticated" error

**Solutions:**
- Ensure login was successful
- Check if token is saved in SharedPreferences
- Verify middleware is applied to routes
- Check token expiration (if using Sanctum)

### Issue: QR scanner not working

**Solutions:**
- Grant camera permissions
- Test on physical device (not emulator)
- Check if `mobile_scanner` package is installed
- Ensure good lighting for QR code

### Issue: Database record not created

**Solutions:**
- Check Laravel logs for errors
- Verify database connection
- Check if tables exist (run migrations)
- Verify foreign key constraints

---

## Next Steps After Testing

1. **Fix any bugs found during testing**
2. **Add jadwal selection UI for guru**
3. **Implement GPS validation (optional)**
4. **Add device ID anti-cheat (optional)**
5. **Switch from MockAuthService to real AuthService**
6. **Update backend URL for production**
7. **Add more comprehensive error handling**

---

**Testing Date:** __________  
**Tested By:** __________  
**Overall Status:** ⬜ Not Started | 🔄 In Progress | ✅ All Passed | ❌ Issues Found
