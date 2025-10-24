import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'set-porn-free-day-result.dart';

class SetPornFreeDayPage extends StatefulWidget {
  const SetPornFreeDayPage({super.key});

  @override
  State<SetPornFreeDayPage> createState() => _SetPornFreeDayPageState();
}

class _SetPornFreeDayPageState extends State<SetPornFreeDayPage> {
  int selectedGoal = 1; // Default to "1 day (recommended)"
  final List<Map<String, dynamic>> goals = [
    {'text': '12 jam', 'value': 0.5, 'recommended': false},
    {'text': '1 hari', 'value': 1, 'recommended': true},
    {'text': '3 hari', 'value': 3, 'recommended': false},
    {'text': '7 hari', 'value': 7, 'recommended': false},
    {'text': '14 hari', 'value': 14, 'recommended': false},
  ];

  void _setGoal() {
    // Get the selected goal text
    final selectedGoalText = goals[selectedGoal]['text'] as String;
    
    // Navigate to result page with the selected goal
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetPornFreeDayResultPage(
          selectedGoal: selectedGoalText,
        ),
      ),
    );
  }

  void _skipForNow() {
    Navigator.pushNamed(context, '/set-checkin-time');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: ListView(
            children: [
              // Main Content
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.large),
                    
                      Container(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        'assets/images/onboarding/porn-victory.png',
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Main instruction
                    Text(
                      'Mari mulai dengan target kecil untuk membangun momentum.',
                      textAlign: TextAlign.center,
                      style: AppText.h2.copyWith(
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.large * 2),
                    
                    // Goal Options
                    Column(
                      children: goals.asMap().entries.map((entry) {
                        final index = entry.key;
                        final goal = entry.value;
                        final isSelected = selectedGoal == index;
                        final isRecommended = goal['recommended'] as bool;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGoal = index;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.large),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.surface,
                                borderRadius: BorderRadius.circular(AppRadius.medium),
                                border: Border.all(
                                  color: isSelected ? AppTheme.primary : AppTheme.textLight.withOpacity(0.3),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  goal['text'] as String,
                                  style: AppText.body.copyWith(
                                    fontSize: 18,
                                    fontWeight: isRecommended ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? AppTheme.primary : (isRecommended ? AppTheme.textDark : AppTheme.textGrey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              // Bottom Buttons
              Column(
                children: [
                  // Set Goal Button
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
                      onPressed: _setGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      child: const Text(
                        'Tetapkan target bebas pornografi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.medium),
                  
                  // Skip Button
                ],
              ),
              
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        ),
      ),
    );
  }
}