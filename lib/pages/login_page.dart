import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CA7A3), // Hijau tosca muda
              Color(0xFF1E3A3A), // Hijau tosca gelap
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),

              // 🔧 Logo Baru
              Image.asset(
                'assets/images/logo.png', // path logo kamu
                width: 120,
                height: 120,
              ),

              const SizedBox(height: 24),

              const Text(
                "“Kamu telah mengambil langkah terberat. Perjalananmu menuju kebebasan dimulai dari sini”",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 56),

              const Text(
                "Masuk / Daftar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "Data kamu aman bersama kami. Kami hanya menyimpan profil\ndan aktivitas akun kamu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // 🔘 Tombol Google Login
              ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                icon: Image.asset(
                  'assets/images/google.png', // pastikan ada file ini juga
                  height: 28,
                ),
                label: const Text(
                  "Lanjutkan Dengan Google",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
