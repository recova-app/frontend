import 'package:flutter/material.dart';
import 'package:recova/pages/login_page.dart';
import 'package:recova/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await _authService.getUserName();
    if (mounted) {
      setState(() => _userName = name);
    }
  }

  // Fungsi untuk logout
  Future<void> _logout(BuildContext context) async {
    await _authService.logout();

    // Navigasi kembali ke LoginPage dan hapus semua rute sebelumnya dari stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: _userName == null
            ? const CircularProgressIndicator() // Tampilkan loading indicator
            : Text(
                'Selamat Datang, $_userName!',
                style: const TextStyle(fontSize: 24),
              ),
      ),
    );
  }
}