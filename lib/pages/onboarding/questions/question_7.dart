import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class Question7 extends StatefulWidget {
  const Question7({super.key});

  @override
  State<Question7> createState() => _Question7State();
}

class _Question7State extends State<Question7> {
  int? selectedOption;
  final List<String> options = [
    'Ya',
    'Tidak',
  ];

  void _selectOption(int index) {
    setState(() {
      selectedOption = index;
    });
    // Auto-navigate to next question when option is selected
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushNamed(context, '/question-8');
    });
  }

  void _skipTest() {
    Navigator.pushNamed(context, '/learning-1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 7 / 8, // Question 7 of 8
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.textGrey,
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.medium),
              
              // Question Label
              Text(
                'Pertanyaan 7',
                style: AppText.body.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppSpacing.medium),
              
              // Question Text
              Text(
                'Apakah kamu menonton pornografi untuk menghindari perasaan sedih?',
                style: AppText.h2.copyWith(
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              
              const SizedBox(height: AppSpacing.large * 2),
              
              // Answer Options
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedOption == index;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                      child: GestureDetector(
                        onTap: () => _selectOption(index),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.large),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.success.withOpacity(0.1) : AppTheme.surface,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                            border: Border.all(
                              color: isSelected ? AppTheme.success : AppTheme.textLight.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon for Yes and No (green checkmark when selected)
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppTheme.success 
                                      : const Color(0xFFF39C12), // Green when selected, Orange when not
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                              
                              const SizedBox(width: AppSpacing.medium),
                              
                              // Option Text
                              Expanded(
                                child: Text(
                                  options[index],
                                  style: AppText.body.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? AppTheme.success : AppTheme.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
