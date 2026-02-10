import 'package:flutter/material.dart';
import 'package:ujikomaplikasi/page/profile.dart';
import 'package:ujikomaplikasi/page/history.dart';
import 'package:ujikomaplikasi/page/jadwal_guru.dart';
import 'package:ujikomaplikasi/page/guru_generate_qr_page.dart';

class GuruDashboardPage extends StatefulWidget {
  const GuruDashboardPage({super.key});

  @override
  State<GuruDashboardPage> createState() => _GuruDashboardPageState();
}

class _GuruDashboardPageState extends State<GuruDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    GuruDashboardHome(),
    HistoryPage(role: 'GURU'),
    JadwalGuruPage(),
    ProfilePage(
      name: 'Bapak Guru',
      role: 'GURU',
      nisOrNip: '1987654321',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 'Home', 0),
              _navItem(Icons.calendar_today, 'Schedule', 1),
              _navItem(Icons.today, 'Jadwal', 2),
              _navItem(Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class GuruDashboardHome extends StatelessWidget {
  const GuruDashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topBar(),
          const SizedBox(height: 30),
          _timer(),
          const SizedBox(height: 30),
          _quickActions(context),
          const SizedBox(height: 30),
          _announcements(),
          const SizedBox(height: 30),
          _recentActivity(),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=11',
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Pagi', style: TextStyle(color: Colors.grey)),
                Text(
                  'Bapak Guru',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        const Icon(Icons.notifications_outlined),
      ],
    );
  }

  Widget _timer() {
    return Column(
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimeBox(value: '09', label: 'HOURS'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(':', style: TextStyle(fontSize: 30)),
            ),
            _TimeBox(value: '41', label: 'MINUTES'),
          ],
        ),
        SizedBox(height: 10),
        Text('Monday, October 23rd', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _qrButton(context),
            const SizedBox(width: 15),
            _action(Icons.edit_calendar, 'Input Izin', Colors.orange),
            const SizedBox(width: 15),
            _action(Icons.assessment, 'Laporan', Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _qrButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
            builder: (_) => const GenerateQrGuruPage(jadwalId: 1),
            ),
          );
        },
        child: _actionBox(
          icon: Icons.qr_code,
          label: 'Generate QR',
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _action(IconData icon, String label, Color color) {
    return Expanded(
      child: _actionBox(icon: icon, label: label, color: color),
    );
  }

  Widget _actionBox({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _announcements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengumuman Sekolah',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              _AnnouncementCard('Rapat Guru', 'Kamis 12:00', Colors.blue),
              SizedBox(width: 15),
              _AnnouncementCard('Libur Nasional', 'Jumat 25 Okt', Colors.orange),
              SizedBox(width: 15),
              _AnnouncementCard('UTS', 'Senin Depan', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Aktivitas Terbaru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 15),
        _ActivityItem(
          icon: Icons.check_circle,
          title: 'Input Nilai UH',
          time: '2 jam lalu',
          color: Colors.green,
        ),
        _ActivityItem(
          icon: Icons.how_to_reg,
          title: 'Absensi Kelas',
          time: '4 jam lalu',
          color: Colors.blue,
        ),
      ],
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _AnnouncementCard(this.title, this.subtitle, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
