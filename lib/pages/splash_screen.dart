import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recova/pages/main_scaffold.dart';
import 'package:recova/pages/login_page.dart';
import 'package:recova/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Tunggu 3 detik untuk efek splash screen
    await Future.delayed(const Duration(seconds: 3));

    final AuthService authService = AuthService();
    // Coba baca token dari storage
    final String? token = await authService.getToken();

    if (!mounted) return;

    // Jika token ada, navigasi ke HomePage. Jika tidak, ke LoginPage.
    final page = token != null ? const MainScaffold() : const LoginPage();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            // const SizedBox(height: 4),
            const Text(
              'Recova',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
