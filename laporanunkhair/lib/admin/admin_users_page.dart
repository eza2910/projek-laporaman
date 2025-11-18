import 'package:flutter/material.dart';
import '../helpers.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    users = await readUsers();
    setState(() {});
  }

  Future<void> deleteUserByNpm(String npm) async {
    await deleteUser(npm);
    _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("User dihapus")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Pengguna")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          return ListTile(
            title: Text(u['nama'] ?? '-'),
            subtitle: Text("NPM: ${u['npm']} | Role: ${u['role']}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteUserByNpm(u['npm']),
            ),
          );
        },
      ),
    );
  }
}
