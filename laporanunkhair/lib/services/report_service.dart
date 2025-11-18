import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🟢 Tambah laporan baru ke Firestore
  static Future<void> addReport(Map<String, dynamic> data) async {
    try {
      print("📤 [DEBUG] Menyimpan laporan ke Firestore...");

      // Gunakan ID dari user (kalau ada), atau buat baru
      final id = data['id'] ?? _db.collection('reports').doc().id;

      await _db.collection('reports').doc(id).set({
        ...data,
        'id': id,
        'status': data['status'] ?? 'Belum Ditindaklanjuti',
        'created_at': FieldValue.serverTimestamp(),
      });

      print("✅ [DEBUG] Laporan berhasil disimpan dengan ID: $id");
    } catch (e, st) {
      print("🔥 [ERROR] addReport gagal: $e");
      print(st);
      rethrow;
    }
  }

  /// 🔵 Ambil laporan berdasarkan ID
  static Future<Map<String, dynamic>?> getReportById(String id) async {
    try {
      final doc = await _db.collection('reports').doc(id).get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      print("🔥 [ERROR] getReportById: $e");
      return null;
    }
  }

  /// 🟡 Update laporan (umum)
  static Future<void> updateReport(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('reports').doc(id).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });
      print("✅ [DEBUG] Laporan diperbarui ($id)");
    } catch (e) {
      print("🔥 [ERROR] updateReport: $e");
      rethrow;
    }
  }

  /// 🟣 Update status laporan oleh admin
  static Future<void> updateReportStatus(String id, String status) async {
    try {
      await _db.collection('reports').doc(id).update({
        'status': status,
        'updated_at': FieldValue.serverTimestamp(),
      });
      print("✅ [DEBUG] Status laporan diubah ke '$status'");
    } catch (e) {
      print("🔥 [ERROR] updateReportStatus: $e");
      rethrow;
    }
  }

  /// 🔴 Hapus laporan
  static Future<void> deleteReport(String id) async {
    try {
      await _db.collection('reports').doc(id).delete();
      print("🗑️ [DEBUG] Laporan dihapus ($id)");
    } catch (e) {
      print("🔥 [ERROR] deleteReport: $e");
      rethrow;
    }
  }

  /// 🟢 Stream semua laporan (Admin)
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllReportsStream() {
    return _db
        .collection('reports')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  /// 🟡 Stream laporan milik user berdasarkan NPM
  static Stream<QuerySnapshot<Map<String, dynamic>>> getReportsByNpm(String npm) {
    return _db
        .collection('reports')
        .where('npm', isEqualTo: npm)
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
