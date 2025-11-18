import 'package:flutter/material.dart';
import '../helpers.dart';

class UserPage extends StatefulWidget {
  final String npm;
  const UserPage({super.key, required this.npm});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard Pengguna",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await logout();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          )
        ],
      ),

      /// ---------------------------------------------------------
      /// 💠 BACKGROUND IMAGE DIPERBAIKI
      /// ---------------------------------------------------------
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/736x/80/db/ed/80dbed77700c602352393c71b285a9ae.jpg"), // ✅ Benar
            fit: BoxFit.cover,
          ),
        ),

        child: _currentIndex == 0
            ? _homeWidget()
            : _currentIndex == 2
                ? _myReportsButton(context)
                : const SizedBox(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/user/add_report',
            arguments: widget.npm,
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 183, 1, 219), // 💜 Ungu sesuai tema
        foregroundColor: Colors.white, // Putih agar ikon terlihat jelas
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? const Color.fromARGB(255, 183, 1, 219) : Colors.grey,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: Icon(
                  Icons.list_alt,
                  color: _currentIndex == 2 ? const Color.fromARGB(255, 183, 1, 219) : Colors.grey,
                ),
                onPressed: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------------------------------------------------
  /// 🟦 HOME CARD
  /// ---------------------------------------------------------
  Widget _homeWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hai, ${widget.npm} 👋",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 183, 1, 219),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Selamat datang di Pelaporan Aman UNKHAIR",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------------------------------------------------
  /// 🟩 BUTTON LAPORAN SAYA (DIPERBAIKI)
  /// ---------------------------------------------------------
  Widget _myReportsButton(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent, // ✅ Background transparan
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.list_alt,
            color: Color.fromARGB(255, 183, 1, 219), // ✅ Ikon ungu
          ),
          label: const Text(
            "Laporan Saya",
            style: TextStyle(
              color: Color.fromARGB(255, 183, 1, 219), // ✅ Teks ungu
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/user/my_reports',
              arguments: widget.npm,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // ✅ Latar transparan
            foregroundColor: const Color.fromARGB(255, 183, 1, 219), // Warna teks & ikon
            side: const BorderSide(
              color: Color.fromARGB(255, 183, 1, 219), // ✅ Border ungu
              width: 2,
            ),
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Sudut melengkung
            ),
            elevation: 0, // Hilangkan bayangan default
          ),
        ),
      ),
    );
  }
}