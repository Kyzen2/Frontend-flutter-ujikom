import 'package:flutter/material.dart';

class JadwalMuridPage extends StatelessWidget {
  const JadwalMuridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Jadwal Pelajaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySection('Hari Ini', [
              _buildScheduleData(
                time: '08:00 - 09:30',
                subject: 'Matematika Peminatan',
                room: 'Ruang 302',
                teacher: 'Bpk. Suryadi',
                color: Colors.blue[50]!,
                iconColor: Colors.blue,
                icon: Icons.calculate,
              ),
              _buildScheduleData(
                time: '10:00 - 11:30',
                subject: 'Fisika Dasar',
                room: 'Lab Fisika',
                teacher: 'Ibu Ratna',
                color: Colors.orange[50]!,
                iconColor: Colors.orange,
                icon: Icons.science,
              ),
            ]),
            const SizedBox(height: 25),
            _buildDaySection('Besok', [
              _buildScheduleData(
                time: '08:00 - 09:30',
                subject: 'Bahasa Indonesia',
                room: 'Ruang 201',
                teacher: 'Ibu Susi',
                color: Colors.purple[50]!,
                iconColor: Colors.purple,
                icon: Icons.book,
              ),
              _buildScheduleData(
                time: '10:00 - 11:30',
                subject: 'Pemrograman Web',
                room: 'Lab Komputer 1',
                teacher: 'Bpk. Budi',
                color: Colors.green[50]!,
                iconColor: Colors.green,
                icon: Icons.computer,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(String title, List<Map<String, dynamic>> schedules) {
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
          time: data['time'],
          subject: data['subject'],
          room: data['room'],
          teacher: data['teacher'],
          color: data['color'],
          iconColor: data['iconColor'],
          icon: data['icon'],
        )),
      ],
    );
  }

  Map<String, dynamic> _buildScheduleData({
    required String time,
    required String subject,
    required String room,
    required String teacher,
    required Color color,
    required Color iconColor,
    required IconData icon,
  }) {
    return {
      'time': time,
      'subject': subject,
      'room': room,
      'teacher': teacher,
      'color': color,
      'iconColor': iconColor,
      'icon': icon,
    };
  }

  Widget _buildScheduleItem({
    required String time,
    required String subject,
    required String room,
    required String teacher,
    required Color color,
    required Color iconColor,
    required IconData icon,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        room,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
