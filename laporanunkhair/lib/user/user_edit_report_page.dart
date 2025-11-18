import 'package:flutter/material.dart';
import '../../../services/report_service.dart';

class UserEditReportPage extends StatefulWidget {
  final String reportId; // ID Firestore
  const UserEditReportPage({super.key, required this.reportId});

  @override
  State<UserEditReportPage> createState() => _UserEditReportPageState();
}

class _UserEditReportPageState extends State<UserEditReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController judulC = TextEditingController();
  final TextEditingController desC = TextEditingController();

  bool _loading = true;
  Map<String, dynamic>? report;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    try {
      final r = await ReportService.getReportById(widget.reportId);
      if (r != null) {
        setState(() {
          report = r;
          judulC.text = r['judul'] ?? '';
          desC.text = r['deskripsi'] ?? '';
          _loading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Laporan tidak ditemukan")),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Gagal memuat laporan: $e")),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await ReportService.updateReport(widget.reportId, {
        'judul': judulC.text.trim(),
        'deskripsi': desC.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Perubahan laporan berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Gagal menyimpan perubahan: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    judulC.dispose();
    desC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Laporan', style: TextStyle(color: Colors.white)),
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
          // Konten edit laporan
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: judulC,
                    decoration: InputDecoration(
                      labelText: 'Judul Laporan',
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
                        v!.trim().isEmpty ? 'Judul wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: desC,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi / Kronologi',
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
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white), // ⭐ Teks input putih
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Deskripsi wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
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
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_loading ? "Menyimpan..." : "Simpan Perubahan", style: const TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _loading ? null : _save,
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