import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewReportsPage extends StatefulWidget {
  const AdminViewReportsPage({super.key});

  @override
  State<AdminViewReportsPage> createState() => _AdminViewReportsPageState();
}

class _AdminViewReportsPageState extends State<AdminViewReportsPage> {
  Color _statusColor(String status) {
    if (status == "Selesai") return Colors.green;
    if (status == "Sedang Diproses") return Colors.orange;
    return const Color.fromARGB(255, 183, 1, 219); // ⭐ Warna ungu untuk status lain
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Semua Laporan", style: TextStyle(color: Colors.white)),
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
          // Konten laporan
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reports')
                .orderBy('tanggal', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada laporan",
                    style: TextStyle(color: Colors.white), // ⭐ Teks putih agar kontras
                  ),
                );
              }

              final reports = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final r = reports[index].data() as Map<String, dynamic>;
                  final id = reports[index].id;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        r['judul'] ?? '(Tanpa Judul)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // ⭐ Teks judul hitam
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pelapor: ${r['nama'] ?? '-'}",
                            style: const TextStyle(color: Colors.grey), // ⭐ Teks abu-abu
                          ),
                          Text(
                            "Tanggal: ${r['tanggal'] ?? '-'}",
                            style: const TextStyle(color: Colors.grey), // ⭐ Teks abu-abu
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(r['status'] ?? '').withOpacity(.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              r['status'] ?? 'Belum Ditindaklanjuti',
                              style: TextStyle(
                                color: _statusColor(r['status'] ?? ''),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          '/admin/report_detail',
                          arguments: id, // 🔥 Firestore doc ID
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}