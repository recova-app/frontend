import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class Learning1 extends StatelessWidget {
  const Learning1({super.key});

  @override
  Widget build(BuildContext context) {
    print('Learning1 build method called'); // Debug print
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              // Main Content Area - Scrollable to prevent overflow
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.large), // Top spacing
                      Container(
                        width: 220,
                        height: 220,
                        child: Image.asset(
                          'assets/images/onboarding/learning-1.png',
                          width: 220,
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.large),

                      // Main Question Text
                      Text(
                        'Mengapa Saya Menonton Begitu Banyak Pornografi?',
                        textAlign: TextAlign.center,
                        style: AppText.h2.copyWith(
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.medium),

                      // Subtitle
                      Text(
                        'Mari kita pelajari bersama tentang dampakdan cara mengatasi kecanduan pornografi',
                        textAlign: TextAlign.center,
                        style: AppText.body.copyWith(
                          color: AppTheme.textGrey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.large), // Bottom spacing
                    ],
                  ),
                ),
              ),

              // Bottom Action Area - Always visible and clickable
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: AppSpacing.medium),
                child: Column(
                  children: [
                    // Continue Button
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
                          Navigator.pushNamed(context, '/learning-2');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.medium,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Selanjutnya',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.medium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
