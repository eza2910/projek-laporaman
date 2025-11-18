import 'package:flutter/material.dart';
import 'helpers.dart'; // Pastikan file ini menyediakan fungsi readUsers dan saveUsers

class AdminAddUserPage extends StatefulWidget {
  const AdminAddUserPage({super.key});

  @override
  State<AdminAddUserPage> createState() => _AdminAddUserPageState();
}

class _AdminAddUserPageState extends State<AdminAddUserPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController npmController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah User", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // Neon purple
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Gambar background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/736x/80/db/ed/80dbed77700c602352393c71b285a9ae.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay gelap
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Konten tambah user
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    labelStyle: const TextStyle(color: Colors.white),
                    hintText: "Masukkan nama pengguna",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Border melengkung
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 183, 1, 219), width: 2), // Neon purple saat fokus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // Teks input putih
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: npmController,
                  decoration: InputDecoration(
                    labelText: "NPM",
                    labelStyle: const TextStyle(color: Colors.white),
                    hintText: "Masukkan NPM pengguna",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 183, 1, 219), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white),
                    hintText: "Masukkan password",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 183, 1, 219), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 1, 219), // Neon purple
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Tombol melengkung
                    ),
                  ),
                  onPressed: () async {
                    // 1. Validasi apakah semua field diisi
                    if (namaController.text.isEmpty || npmController.text.isEmpty || passController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Isi semua data!")),
                      );
                      return;
                    }

                    // 2. Ambil data user yang sudah ada
                    List users = await readUsers();

                    // 3. Cek apakah NPM sudah ada
                    bool npmExists = users.any((user) => user['npm'] == npmController.text);

                    if (npmExists) {
                      // 4. Jika NPM sudah ada, tampilkan pesan error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("NPM sudah terdaftar! Gunakan NPM lain.")),
                      );
                      return;
                    }

                    // 5. Jika NPM belum ada, tambahkan user baru
                    users.add({
                      "nama": namaController.text,
                      "npm": npmController.text,
                      "password": passController.text,
                      "role": "user"
                    });

                    await saveUsers(users);
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}