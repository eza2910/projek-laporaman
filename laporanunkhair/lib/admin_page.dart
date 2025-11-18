import 'package:flutter/material.dart';
import '../helpers.dart'; // ✅ Pastikan file helpers sudah ada dan path benar

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // AppBar ungu
        foregroundColor: Colors.white, // Ikon logout putih
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Stack(
        children: [
          // Gambar background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/736x/be/8c/45/be8c457b5e22bbb52d03026f2e0d281b.jpg"), // 🔗 Ganti link ini
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
          // Konten admin
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                const Text(
                  "Welcome, Admin!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ⭐ Teks putih agar kontras
                  ),
                ),
                const SizedBox(height: 35),

                // ✅ Tombol Lihat Semua Laporan
                _adminMenuButton(
                  context,
                  icon: Icons.report,
                  label: "Lihat Semua Laporan",
                  route: '/admin/reports',
                ),
                const SizedBox(height: 25),

                // ✅ Tombol Tambah Pengguna
                _adminMenuButton(
                  context,
                  icon: Icons.person_add,
                  label: "Tambah Pengguna",
                  route: '/admin/add_user',
                ),
                const SizedBox(height: 25),

                // ✅ Tombol Baru: Manajemen User
                _adminMenuButton(
                  context,
                  icon: Icons.manage_accounts,
                  label: "Manajemen User",
                  route: '/admin/manage_users',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white), // ⭐ Ikon tombol putih
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white, // ⭐ Teks tombol putih
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 183, 1, 219), // ⭐ Warna tombol ungu
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // ⭐ Sudut tombol melengkung
          ),
          elevation: 4, // ⭐ Bayangan tombol
        ),
      ),
    );
  }
}