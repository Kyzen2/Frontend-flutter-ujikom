import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ujikomaplikasi/api/attendance_service.dart';

class GenerateQrGuruPage extends StatefulWidget {
  const GenerateQrGuruPage({super.key});

  @override
  State<GenerateQrGuruPage> createState() => _GenerateQrGuruPageState();
}

class _GenerateQrGuruPageState extends State<GenerateQrGuruPage> {
  String? qrData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    generateQR();
  }

  Future<void> generateQR() async {
    final res = await AttendanceService().createSession();

    setState(() {
      qrData = res['qr_code']; // sesuaikan response backend
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate QR")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : QrImageView(
                data: qrData ?? "",
                size: 250,
              ),
      ),
    );
  }
}
