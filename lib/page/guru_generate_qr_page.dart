import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ujikomaplikasi/api/attendance_service.dart';

class GenerateQrGuruPage extends StatefulWidget {
  final int jadwalId;
  const GenerateQrGuruPage({super.key, required this.jadwalId});

  @override
  State<GenerateQrGuruPage> createState() => _GenerateQrGuruPageState();
}

class _GenerateQrGuruPageState extends State<GenerateQrGuruPage> {
  String? qrToken;
  bool loading = true;
  String? errorMessage;
  DateTime? sessionTime;

  @override
  void initState() {
    super.initState();
    generateQR();
  }

  Future<void> generateQR() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final res = await AttendanceService().createSession(jadwalId: widget.jadwalId);

      if (!mounted) return;

      if (res['status'] == 'success') {
        setState(() {
          qrToken = res['token_qr'];
          sessionTime = DateTime.now();
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = res['message'] ?? 'Gagal membuat sesi';
          loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loading ? null : generateQR,
            tooltip: 'Refresh QR Code',
          ),
        ],
      ),
      body: Center(
        child: loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating QR Code...'),
                ],
              )
            : errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: generateQR,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        const Text(
                          'QR Code Berhasil Dibuat',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Session Info
                        if (sessionTime != null)
                          Text(
                            'Dibuat pada: ${_formatDateTime(sessionTime!)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        const SizedBox(height: 24),

                        // QR Code
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: qrToken ?? "",
                            version: QrVersions.auto,
                            size: 280,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Instruksi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '1. Tampilkan QR code ini ke siswa\n'
                                '2. Siswa scan menggunakan aplikasi\n'
                                '3. Absensi otomatis tersimpan',
                                style: TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Token Info (for debugging)
                        if (qrToken != null)
                          Text(
                            'Token: ${qrToken!.substring(0, 8)}...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontFamily: 'monospace',
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${days[dt.weekday % 7]}, ${dt.day} ${months[dt.month - 1]} ${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
