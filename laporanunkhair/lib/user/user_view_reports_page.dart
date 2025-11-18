import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/report_service.dart';
import '../helpers.dart';

class UserViewReportsPage extends StatefulWidget {
  final String npm;
  const UserViewReportsPage({super.key, required this.npm});

  @override
  State<UserViewReportsPage> createState() => _UserViewReportsPageState();
}

class _UserViewReportsPageState extends State<UserViewReportsPage> {
  String? npm;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await getLoggedInUser();
    print('🔥 Logged user data: $user');
    setState(() {
      npm = user?['npm'] ?? widget.npm;
      loading = false;
    });
  }

  Future<void> _deleteReport(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Laporan"),
        content: const Text("Yakin ingin menghapus laporan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ReportService.deleteReport(id);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("✅ Laporan dihapus")));
      }
    }
  }

  Color _statusColor(String status) {
    if (status == "Selesai") return Colors.green;
    if (status == "Sedang Diproses") return Colors.orange;
    return const Color.fromARGB(255, 183, 1, 219); // Ungu untuk status lain
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (npm == null) {
      return const Scaffold(
        body: Center(child: Text("❌ Gagal memuat data pengguna")),
      );
    }

    print("📡 Mendengarkan laporan untuk NPM: $npm");

    final reportQuery = FirebaseFirestore.instance
        .collection('reports')
        .where('npm', isEqualTo: npm);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Saya", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // AppBar ungu
        foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Ikon back putih
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 183, 1, 219).withOpacity(0.9), // Ungu atas
              const Color.fromARGB(255, 22, 22, 22).withOpacity(0.9), // Putih bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: reportQuery.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada laporan",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }

            final reports = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: reports.length,
              itemBuilder: (context, i) {
                final data = reports[i].data() as Map<String, dynamic>;
                final id = reports[i].id;

                final judul = data['judul'] ?? '(Tanpa Judul)';
                final nama = data['nama'] ?? '-';
                final tanggal = data['tanggal'] ?? '-';
                final status = data['status'] ?? 'Belum Ditindaklanjuti';
                final deskripsi = data['deskripsi'] ?? 'Tidak ada deskripsi';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pelapor: $nama", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text("Tanggal: $tanggal", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(status).withOpacity(.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _statusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol edit — SELALU muncul
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 183, 1, 219)), // ✏️ Ikon pena edit ungu
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/user/edit_report',
                              arguments: id,
                            );
                          },
                        ),
                        // Tombol hapus
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // 🗑️ Ikon hapus merah
                          onPressed: () => _deleteReport(id),
                        ),
                      ],
                    ),
                    onTap: () => _showDetailDialog(judul, deskripsi, tanggal, status),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDetailDialog(
      String judul, String deskripsi, String tanggal, String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(judul, style: const TextStyle(color: Color.fromARGB(255, 183, 1, 219))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal: $tanggal", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Status: $status",
                style: TextStyle(
                  color: _statusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(deskripsi),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Tutup", style: TextStyle(color: Color.fromARGB(255, 183, 1, 219))),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}