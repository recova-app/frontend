import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class Learning3 extends StatelessWidget {
  const Learning3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bed with Broken Heart Illustration and Main Content
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      child: Image.asset(
                        'assets/images/onboarding/learning-3.png',
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),

                    // Main Title
                    Text(
                      'Ini akan memburuk',
                      textAlign: TextAlign.center,
                      style: AppText.h2.copyWith(
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.medium),

                    // Description
                    Text(
                      'Seiring waktu, otak kamu mulai mengaitkan pornografi dengan kesenangan. Hal ini dapatmenyebabkan kurangnya minat  pada pasangan potensial, penurunan libido, dan masalah hubungan.',
                      textAlign: TextAlign.center,
                      style: AppText.body.copyWith(
                        color: AppTheme.textGrey,
                        height: 1.4,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Navigation Area
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Navigation Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.textGrey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppTheme.textGrey,
                              size: 20,
                            ),
                          ),
                        ),

                        // Next Button
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Navigate to next learning page or complete learning
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/learning-4',
                                (route) => false,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.medium),

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