import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/report_service.dart';

class AdminReportDetailPage extends StatefulWidget {
  const AdminReportDetailPage({super.key});

  @override
  State<AdminReportDetailPage> createState() => _AdminReportDetailPageState();
}

class _AdminReportDetailPageState extends State<AdminReportDetailPage> {
  late String reportId;
  Map<String, dynamic>? reportData;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reportId = ModalRoute.of(context)!.settings.arguments as String;
    _loadReport();
  }

  Future<void> _loadReport() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportId)
          .get();

      if (doc.exists) {
        setState(() {
          reportData = doc.data();
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Laporan tidak ditemukan")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal memuat laporan: $e")),
      );
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await ReportService.updateReportStatus(reportId, newStatus);
      setState(() {
        reportData!['status'] = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Status diubah menjadi '$newStatus'"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal mengubah status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (reportData == null) {
      return const Scaffold(
        body: Center(child: Text("Data laporan tidak ditemukan")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // AppBar ungu
        foregroundColor: Colors.white, // Ikon back putih
      ),
      body: Stack(
        children: [
          // Gambar background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/736x/9d/09/0c/9d090cff65acb1b9d235bbdeb54ef2ab.jpg"), // 🔗 Ganti link ini
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay gelap
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), // ⭐ Overlay gelap
            ),
          ),
          // Konten detail laporan
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  reportData!['judul'] ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ⭐ Teks judul putih agar kontras
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Nama Pelapor: ${reportData!['nama'] ?? '-'}",
                  style: const TextStyle(color: Colors.white), // ⭐ Teks putih
                ),
                Text(
                  "NPM: ${reportData!['npm'] ?? '-'}",
                  style: const TextStyle(color: Colors.white), // ⭐ Teks putih
                ),
                Text(
                  "Tanggal: ${reportData!['tanggal'] ?? '-'}",
                  style: const TextStyle(color: Colors.white), // ⭐ Teks putih
                ),
                const SizedBox(height: 16),
                const Text(
                  "Deskripsi:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ⭐ Teks putih
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // ⭐ Background teks deskripsi
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reportData!['deskripsi'] ?? '-',
                    style: const TextStyle(color: Colors.black), // ⭐ Teks hitam di background putih
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white), // ⭐ Garis pemisah putih
                const SizedBox(height: 10),
                Text(
                  "Status Saat Ini:",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ⭐ Teks putih
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 183, 1, 219).withOpacity(0.2), // ⭐ Background status ungu muda
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    reportData!['status'] ?? 'Belum Ditindaklanjuti',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 183, 1, 219), // ⭐ Teks status ungu
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ubah Status:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ⭐ Teks putih
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // ⭐ Warna ungu
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _updateStatus("Belum Ditindaklanjuti"),
                      child: const Text("Belum Ditindaklanjuti"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _updateStatus("Sedang Diproses"),
                      child: const Text("Sedang Diproses"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _updateStatus("Selesai"),
                      child: const Text("Selesai"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}