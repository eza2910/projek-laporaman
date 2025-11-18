import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// =======================
/// ✅ USERS DATABASE SYSTEM
/// =======================

File? _userFile;
const String usersFile = 'users.json';

Future<void> _initUsersFile() async {
  if (_userFile != null) return;

  final dir = await getApplicationDocumentsDirectory();
  _userFile = File('${dir.path}/$usersFile');

  if (!await _userFile!.exists()) {
    await _userFile!.writeAsString(jsonEncode([]));
  }
}

// ✅ Read all users
Future<List<dynamic>> readUsers() async {
  await _initUsersFile();
  final text = await _userFile!.readAsString();
  if (text.isEmpty) return [];
  return jsonDecode(text);
}

// ✅ Save updated users list
Future<void> saveUsers(List<dynamic> list) async {
  await _initUsersFile();
  await _userFile!.writeAsString(jsonEncode(list));
}

// ✅ Delete user by NIM
Future<void> deleteUser(String nim) async {
  final list = await readUsers();
  list.removeWhere((u) => u['npm'] == nim);
  await saveUsers(list);
}
// ✅ Ambil semua user (convert ke List<Map>)
Future<List<Map<String, dynamic>>> getAllUsers() async {
  final data = await readUsers();
  return List<Map<String, dynamic>>.from(data);
}

/// =======================
/// ✅ LOGIN SESSION SYSTEM
/// =======================

File? _currentUserFile;
const String currentUserFile = 'current_user.json';

Future<void> _initCurrentUserFile() async {
  if (_currentUserFile != null) return;

  final dir = await getApplicationDocumentsDirectory();
  _currentUserFile = File('${dir.path}/$currentUserFile');

  if (!await _currentUserFile!.exists()) {
    await _currentUserFile!.writeAsString('');
  }
}

// ✅ Save user session on login
Future<void> saveLoggedInUser(Map<String, dynamic> userData) async {
  await _initCurrentUserFile();
  await _currentUserFile!.writeAsString(jsonEncode(userData));
}

// ✅ Get the logged-in user session
Future<Map<String, dynamic>?> getLoggedInUser() async {
  await _initCurrentUserFile();
  final text = await _currentUserFile!.readAsString();

  if (text.isEmpty || text.trim().isEmpty) return null;

  try {
    return jsonDecode(text);
  } catch (_) {
    return null;
  }
}

// ✅ Logout user
Future<void> logout() async {
  await _initCurrentUserFile();
  if (await _currentUserFile!.exists()) {
    await _currentUserFile!.writeAsString('');
  }
}
