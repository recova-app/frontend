import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';

class SetCheckinTimePage extends StatefulWidget {
  const SetCheckinTimePage({super.key});

  @override
  State<SetCheckinTimePage> createState() => _SetCheckinTimePageState();
}

class _SetCheckinTimePageState extends State<SetCheckinTimePage> {
  int selectedTime = 3; // Default to "10 pm"
  final List<String> times = [
    '7 pm',
    '8 pm', 
    '9 pm',
    '10 pm',
    '11 pm',
    '12 pm',
    '1 am',
    '2 am',
    '3 am',
    '4 am',
    '5 am',
    '6 am',
    '7 am',
    '8 am',
    '9 am',
    '10 am',
    '11 am',
    '12 am',
    '1 pm',
    '2 pm',
    '3 pm',
    '4 pm',
    '5 pm',
    '6 pm',
  ];

  void _setCheckinTime() {
    Navigator.pushNamed(context, '/preparing-test-result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.large ),
                    
                        Container(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        'assets/images/onboarding/set-time.png',
                        width: 220,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.large),         
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Main instruction
                    Text(
                      'Kapan Waktu yang kamu mau untuk daily check in setiap harinya?',
                      textAlign: TextAlign.center,
                      style: AppText.h2.copyWith(
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Time Picker
                    Expanded(
                      child: Container(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 60,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedTime = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              if (index < 0 || index >= times.length) return null;
                              
                              final time = times[index];
                              final isSelected = selectedTime == index;
                              
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: isSelected ? Border(
                                    top: BorderSide(color: AppTheme.textLight.withOpacity(0.3)),
                                    bottom: BorderSide(color: AppTheme.textLight.withOpacity(0.3)),
                                  ) : null,
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: isSelected ? 32 : 24,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppTheme.textDark : AppTheme.textGrey,
                                  ),
                                ),
                              );
                            },
                            childCount: times.length,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

                const SizedBox(height: AppSpacing.large ),
              
              // Bottom Button
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
                  onPressed: _setCheckinTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: const Text(
                    'Atur Waktu Check-In',
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
      ),
    );
  }
}
