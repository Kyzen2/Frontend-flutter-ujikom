import 'package:flutter/material.dart';
import 'package:ujikomaplikasi/page/guru_generate_qr_page.dart';

class JadwalGuruPage extends StatelessWidget {
  const JadwalGuruPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Consistent background
      appBar: AppBar(
        title: const Text(
          'Jadwal Mengajar',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // No back button since it's a main tab
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySection(context, 'Hari Ini', [
              _buildScheduleData(
                id: 1,
                time: '08:00 AM',
                className: 'X RPL 1',
                subject: 'Web Programming',
                room: 'Lab 01',
                color: Colors.blue[50]!,
              ),
              _buildScheduleData(
                id: 2,
                time: '10:00 AM',
                className: 'XI TKJ 2',
                subject: 'Network Administration',
                room: 'Lab 03',
                color: Colors.orange[50]!,
              ),
            ]),
            const SizedBox(height: 25),
            _buildDaySection(context, 'Besok', [
              _buildScheduleData(
                id: 3,
                time: '09:00 AM',
                className: 'XII MM 1',
                subject: 'Multimedia Design',
                room: 'Lab Multimedia',
                color: Colors.purple[50]!,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(BuildContext context, String title, List<Map<String, dynamic>> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        ...schedules.map((data) => _buildScheduleItem(
          context: context,
          id: data['id'],
          time: data['time'],
          className: data['className'],
          subject: data['subject'],
          room: data['room'],
          color: data['color'],
        )),
      ],
    );
  }

  Map<String, dynamic> _buildScheduleData({
    required int id,
    required String time,
    required String className,
    required String subject,
    required String room,
    required Color color,
  }) {
    return {
      'id': id,
      'time': time,
      'className': className,
      'subject': subject,
      'room': room,
      'color': color,
    };
  }

  Widget _buildScheduleItem({
    required BuildContext context,
    required int id,
    required String time,
    required String className,
    required String subject,
    required String room,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenerateQrGuruPage(jadwalId: id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$subject • $room',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
