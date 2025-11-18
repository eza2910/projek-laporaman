import 'package:flutter/material.dart';
import '../helpers.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({super.key});

  @override
  State<AdminUserManagementPage> createState() =>
      _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  List<Map<String, dynamic>> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final result = await readUsers(); // ✅ pakai readUsers()
    setState(() {
      users = List<Map<String, dynamic>>.from(result);
      loading = false;
    });
  }

  Future<void> removeUser(String npm) async {
    await deleteUser(npm); // ✅ sesuai key JSON
    await loadUsers();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User berhasil dihapus")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen User", style: TextStyle(color: Colors.white)),
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
          // Konten manajemen user
          loading
              ? const Center(child: CircularProgressIndicator())
              : users.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada user terdaftar",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 183, 1, 219).withOpacity(0.2), // ⭐ Background ikon ungu muda
                                borderRadius: BorderRadius.circular(20), // ⭐ Ikon bulat
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 24,
                                color: Color.fromARGB(255, 183, 1, 219), // ⭐ Ikon ungu
                              ),
                            ),
                            title: Text(
                              user["nama"] ?? "Tanpa Nama",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 183, 1, 219), // 💜 UNGU NEON
                              ),
                            ),
                            subtitle: Text(
                              "NPM: ${user["npm"] ?? "-"}",
                              style: TextStyle(
                                color: Colors.grey[400], // ⭐ NPM abu-abu terang
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red, // ⭐ Ikon hapus merah
                              ),
                              onPressed: () => removeUser(user["npm"]), // ✅ fix
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}