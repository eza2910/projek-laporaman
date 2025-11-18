import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Dibuat otomatis setelah `flutterfire configure`
// Pages
import 'login_page.dart';
import 'admin_page.dart';
import 'user_page.dart';
import 'admin/admin_view_reports_page.dart';
import 'admin_add_user_page.dart';
import 'admin/admin_user_management_page.dart';
import 'user/user_add_report_page.dart';
import 'user/user_view_reports_page.dart';
import 'user/user_edit_report_page.dart';
import 'admin/admin_report_detail_page.dart';
import 'admin/admin_manage_reports_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi Firebaseadmin
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapor Aman UNKHAIR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF6F9FF),
        useMaterial3: true,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF1565C0),
          unselectedItemColor: Colors.grey,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Color(0xFF1565C0)),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
            textStyle: const WidgetStatePropertyAll(
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),

      // ✅ Halaman awal
      initialRoute: '/login',

      // 🔹 Route statis
      routes: {
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminPage(),
        '/admin/reports': (context) => const AdminViewReportsPage(),
        '/admin/add_user': (context) => const AdminAddUserPage(),
        '/admin/manage_users': (context) => const AdminUserManagementPage(),
        '/admin/report_detail': (context) => const AdminReportDetailPage(),
        '/admin/manage_reports': (context) => const AdminManageReportsPage(),

      },

      // 🔸 Route dinamis (pakai argument)
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/user':
            final npm = settings.arguments as String?;
            if (npm == null || npm.isEmpty) {
              return _errorRoute("NPM tidak ditemukan");
            }
            return MaterialPageRoute(builder: (_) => UserPage(npm: npm));

          case '/user/add_report':
            final npm = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => UserAddReportPage(npm: npm ?? ""),
            );

          case '/user/my_reports':
            final npm = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => UserViewReportsPage(npm: npm ?? ""),
            );

          case '/user/edit_report':
            final reportId = settings.arguments as String?; // 🔥 Firestore pakai String ID
            if (reportId == null) {
              return _errorRoute("ID laporan tidak ditemukan");
            }
            return MaterialPageRoute(
              builder: (_) => UserEditReportPage(reportId: reportId),
            );

          case '/admin/report_detail':
            final reportId = settings.arguments as String?;
            if (reportId == null) {
              return _errorRoute("ID laporan tidak ditemukan");
            }
            return MaterialPageRoute(
              builder: (_) => const AdminReportDetailPage(),
              settings: RouteSettings(arguments: reportId),
            );

          default:
            return _errorRoute("Halaman tidak ditemukan");
        }
      },
    );
  }

  // 🔻 Halaman error umum
  Route _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
