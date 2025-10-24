import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WhyCheckinPage extends StatelessWidget {
  const WhyCheckinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: ListView(
            children: [
              // Tombol kembali di bagian atas
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.textGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Gambar utama
              Container(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/images/onboarding/why-checkin.png',
                  width: 220,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 60),

              // Teks utama
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppText.h2.copyWith(
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    const TextSpan(text: 'Daily Checkin selama satu menit '),
                    TextSpan(
                      text: 'setiap hari',
                      style: AppText.h2.copyWith(
                        color: AppTheme.primary,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' akan membimbingmu untuk\nmembuat pilihan yang akan merubah hidupmu.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Teks manfaat
              Text(
                'Kebanyakan pengguna mulai merasakan manfaatnya dalam minggu pertama.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(
                  color: AppTheme.textGrey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              // Tombol "Mengapa check-in?"
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/set-checkin-time');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.medium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: const Text(
                    'Atur Waktu Check-in',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.medium),

              // Tombol "Atur Waktu Check-in"
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        ),
      ),
    );
  }
}
