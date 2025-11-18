import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});

  @override
  State<ViewUsersPage> createState() => _ViewUsersPageState();
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/users.json';
      final file = File(filePath);

      if (!file.existsSync()) {
        setState(() => users = []);
        return;
      }

      final data = jsonDecode(file.readAsStringSync());
      setState(() => users = data);
    } catch (e) {
      debugPrint("Error loading users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar User"),
      ),
      body: users.isEmpty
          ? const Center(child: Text("Belum ada user terdaftar"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user["nama"] ?? "No Name"),
                    subtitle: Text("NPM: ${user["npm"]} • Role: ${user["role"]}"),
                  ),
                );
              },
            ),
    );
  }
}
