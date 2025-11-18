import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/report_service.dart';

class AdminManageReportsPage extends StatelessWidget {
  const AdminManageReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Laporan Pengguna")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ReportService.getAllReportsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada laporan"));
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final data = reports[i].data() as Map<String, dynamic>;
              final id = reports[i].id;

              final judul = data['judul'] ?? 'Tanpa Judul';
              final nama = data['nama'] ?? '-';
              final npm = data['npm'] ?? '-';
              final tanggal = data['tanggal'] ?? '-';
              final status = data['status'] ?? 'Belum Ditindaklanjuti';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    judul,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pelapor: $nama"),
                      Text("NPM: $npm"),
                      Text("Tanggal: $tanggal"),
                      const SizedBox(height: 5),
                      Text(
                        "Status: $status",
                        style: TextStyle(
                          color: status == 'Selesai'
                              ? Colors.green
                              : status == 'Sedang Diproses'
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      await ReportService.updateReportStatus(id, value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("✅ Status diubah ke '$value'"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Belum Ditindaklanjuti',
                        child: Text('Belum Ditindaklanjuti'),
                      ),
                      const PopupMenuItem(
                        value: 'Sedang Diproses',
                        child: Text('Sedang Diproses'),
                      ),
                      const PopupMenuItem(
                        value: 'Selesai',
                        child: Text('Selesai'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
