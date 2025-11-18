import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/report_service.dart';
import '../helpers.dart';

class UserAddReportPage extends StatefulWidget {
  final String npm;
  const UserAddReportPage({super.key, required this.npm});

  @override
  State<UserAddReportPage> createState() => _UserAddReportPageState();
}

class _UserAddReportPageState extends State<UserAddReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController titleC = TextEditingController();
  final TextEditingController descC = TextEditingController();

  bool _loading = false;
  String? userNpm;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await getLoggedInUser();
    setState(() {
      userNpm = user?['npm'] ?? widget.npm;
    });
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (userNpm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Data pengguna tidak ditemukan")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      final id = FirebaseFirestore.instance.collection('reports').doc().id;

      final reportData = {
        'id': id,
        'npm': userNpm,
        'nama': namaC.text.trim(),
        'judul': titleC.text.trim(),
        'deskripsi': descC.text.trim(),
        'tanggal': now,
        'status': 'Belum Ditindaklanjuti',
      };

      await ReportService.addReport(reportData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Laporan berhasil dikirim ke sistem"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Gagal mengirim laporan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    namaC.dispose();
    titleC.dispose();
    descC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Laporan", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // AppBar ungu
        foregroundColor: Colors.white, // Ikon back putih
      ),
      body: Stack(
        children: [
          // Gambar background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/736x/80/db/ed/80dbed77700c602352393c71b285a9ae.jpg"), // 🔗 Ganti link ini
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
          // Konten tambah laporan
          userNpm == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: namaC,
                          decoration: InputDecoration(
                            labelText: "Nama Pelapor",
                            labelStyle: const TextStyle(color: Colors.white), // ⭐ Label putih
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2), // ⭐ Background input transparan
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border melengkung
                              borderSide: const BorderSide(color: Colors.white), // ⭐ Border putih
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border fokus melengkung
                              borderSide: const BorderSide(color: Color.fromARGB(255, 183, 1, 219), width: 2), // ⭐ Border fokus ungu
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border aktif melengkung
                              borderSide: const BorderSide(color: Colors.white), // ⭐ Border aktif putih
                            ),
                          ),
                          style: const TextStyle(color: Colors.white), // ⭐ Teks input putih
                          validator: (v) =>
                              v!.isEmpty ? "Nama wajib diisi" : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: titleC,
                          decoration: InputDecoration(
                            labelText: "Judul Laporan",
                            labelStyle: const TextStyle(color: Colors.white), // ⭐ Label putih
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2), // ⭐ Background input transparan
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border melengkung
                              borderSide: const BorderSide(color: Colors.white), // ⭐ Border putih
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border fokus melengkung
                              borderSide: const BorderSide(color: Color.fromARGB(255, 183, 1, 219), width: 2), // ⭐ Border fokus ungu
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border aktif melengkung
                              borderSide: const BorderSide(color: Colors.white), // ⭐ Border aktif putih
                            ),
                          ),
                          style: const TextStyle(color: Colors.white), // ⭐ Teks input putih
                          validator: (v) =>
                              v!.isEmpty ? "Judul wajib diisi" : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: descC,
                          decoration: InputDecoration(
                            labelText: "Deskripsi",
                            labelStyle: const TextStyle(color: Colors.white), // ⭐ Label putih
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2), // ⭐ Background input transparan
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border melengkung
                              borderSide: const BorderSide(color: Colors.white), // ⭐ Border putih
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border fokus melengkung
                              borderSide: const BorderSide(color: Color.fromARGB(255, 183, 1, 219), width: 2), // ⭐ Border fokus ungu
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // ⭐ Border aktif melengkung
                              borderSide: const BorderSide(color: Colors.white), // ⭐ Border aktif putih
                            ),
                          ),
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white), // ⭐ Teks input putih
                          validator: (v) =>
                              v!.isEmpty ? "Deskripsi wajib diisi" : null,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 183, 1, 219), // ⭐ Warna tombol ungu
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // ⭐ Tombol melengkung
                              ),
                            ),
                            icon: _loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(_loading ? "Mengirim..." : "Kirim Laporan", style: const TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _loading ? null : _saveReport,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}