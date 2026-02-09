import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String role; // 'SISWA' or 'GURU'

  const HistoryPage({
    super.key,
    this.role = 'SISWA',
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'This Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.role == 'GURU' ? 'Riwayat Mengajar' : 'My History',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            // Only pop if we can, otherwise we are likely in a bottom nav tab
             if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton('This Week'),
                _buildFilterButton('This Month'),
                _buildFilterButton('All Time'),
              ],
            ),
            const SizedBox(height: 25),

            // Today Section
            const Text(
              'TODAY, OCT 24',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            if (widget.role == 'SISWA') ...[
              _buildHistoryItem(
                title: 'Advanced Mathematics',
                subtitle: '08:00 AM • Room 302',
                status: 'HADIR',
                statusColor: Colors.green[100]!,
                statusTextColor: Colors.green,
                icon: Icons.calculate,
                iconBgColor: Colors.blue[50]!,
                iconColor: Colors.blue,
              ),
              _buildHistoryItem(
                title: 'Physics Lab',
                subtitle: '10:15 AM • Lab 1',
                status: 'TERLAMBAT',
                statusColor: Colors.orange[100]!,
                statusTextColor: Colors.orange[800]!,
                icon: Icons.science,
                iconBgColor: Colors.orange[50]!,
                iconColor: Colors.orange,
              ),
            ] else ...[
               _buildHistoryItem(
                title: 'X RPL 1 - Web Prog.',
                subtitle: '08:00 AM • Lab 01',
                status: '32/32 HADIR',
                statusColor: Colors.green[100]!,
                statusTextColor: Colors.green,
                icon: Icons.code,
                iconBgColor: Colors.blue[50]!,
                iconColor: Colors.blue,
              ),
               _buildHistoryItem(
                title: 'XI TKJ 2 - Network',
                subtitle: '10:15 AM • Lab 03',
                status: '30/32 HADIR',
                statusColor: Colors.blue[100]!,
                statusTextColor: Colors.blue[800]!,
                icon: Icons.wifi,
                iconBgColor: Colors.purple[50]!,
                iconColor: Colors.purple,
              ),
            ],

            const SizedBox(height: 25),

            // Yesterday Section
            const Text(
              'YESTERDAY, OCT 23',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
             if (widget.role == 'SISWA') ...[
              _buildHistoryItem(
                title: 'English Literature',
                subtitle: '09:00 AM • Room 105',
                status: 'HADIR',
                statusColor: Colors.green[100]!,
                statusTextColor: Colors.green,
                icon: Icons.translate,
                iconBgColor: Colors.purple[50]!,
                iconColor: Colors.purple,
              ),
              _buildHistoryItem(
                title: 'World History',
                subtitle: '11:30 AM • Hall C',
                status: 'HADIR',
                statusColor: Colors.green[100]!,
                statusTextColor: Colors.green,
                icon: Icons.history_edu,
                iconBgColor: Colors.blue[50]!,
                iconColor: Colors.blue,
              ),
            ] else ...[
               _buildHistoryItem(
                title: 'XII MM 1 - Design',
                subtitle: '09:00 AM • Lab MM',
                status: '28/30 HADIR',
                statusColor: Colors.green[100]!,
                statusTextColor: Colors.green,
                icon: Icons.brush,
                iconBgColor: Colors.pink[50]!,
                iconColor: Colors.pink,
              ),
            ],

            const SizedBox(height: 30),

            // Weekly Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WEEKLY SUMMARY',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.role == 'GURU' ? '98% Mengajar' : '94% Hadir',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.role == 'GURU' ? '12 Classes this week' : '16 Classes this week',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 0.94,
                            strokeWidth: 6,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                         Center(
                          child: Icon(
                            widget.role == 'GURU' ? Icons.check_circle : Icons.trending_up,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    bool isSelected = _selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
