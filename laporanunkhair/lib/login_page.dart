import 'package:flutter/material.dart';
import 'helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController npmController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _autoLoginCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/736x/5f/5a/b5/5f5ab56e532d0f3d9ecc8e9dff4e6e25.jpg"), // 🔗 Ganti link ini
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay gelap
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4), // ⭐ Overlay gelap
            ),
          ),
          // Konten login
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Image.asset('assets/images/api.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lapor Aman UNKHAIR",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // ⭐ Warna teks putih agar kontras
                      ),
                    ),

                    const SizedBox(height: 30),

                    _inputField(npmController, "NPM"),
                    const SizedBox(height: 12),
                    _inputField(passController, "Password", password: true),
                    const SizedBox(height: 18),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: const Color.fromARGB(255, 91, 42, 100), // ⭐ Warna tombol biru
                        foregroundColor: Colors.white, // ⭐ Teks tombol putih
                      ),
                      onPressed: _login,
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController c, String label,
      {bool password = false}) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: const TextStyle(color: Colors.white), // ⭐ Warna label putih
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ⭐ Border input putih
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // ⭐ Border fokus biru
        ),
      ),
      obscureText: password,
      style: const TextStyle(color: Colors.white), // ⭐ Warna teks input putih
    );
  }

  Future<void> _login() async {
    String npm = npmController.text.trim();
    String pass = passController.text.trim();

    if (npm.isEmpty || pass.isEmpty) {
      _toast("Isi semua data!");
      return;
    }

    // 🔐 Login admin otomatis jika NPM dan password adalah "admin"
    if (npm == "admin" && pass == "admin") {
      // ✅ Simpan sesi login admin
      await saveLoggedInUser({
        'npm': "admin",
        'name': "Admin",
        'email': "admin@unkhair.ac.id",
        'role': "admin",
      });

      // ✅ Redirect ke admin page
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    List users = await readUsers();

    for (var u in users) {
      if (u['npm'] == npm && u['password'] == pass) {
        // ✅ Simpan sesi login user
        await saveLoggedInUser({
          'npm': u['npm'],
          'name': u['name'],
          'email': u['email'],
          'role': u['role'],
        });

        // ✅ Redirect berdasarkan role
        if (u['role'] == "admin") {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(
            context,
            '/user',
            arguments: u['npm'],
          );
        }
        return;
      }
    }

    _toast("Login gagal! Periksa akun anda");
  }

  /// ✅ Jika sudah login → langsung masuk tanpa login ulang
  Future<void> _autoLoginCheck() async {
    final user = await getLoggedInUser();
    if (user == null) return;

    if (!mounted) return;

    Future.delayed(Duration.zero, () {
      if (user['role'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/user',
          arguments: user['npm'],
        );
      }
    });
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}