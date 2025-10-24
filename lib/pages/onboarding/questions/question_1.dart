import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class Question1 extends StatefulWidget {
  const Question1({super.key});

  @override
  State<Question1> createState() => _Question1State();
}

class _Question1State extends State<Question1> {
  String? selectedAnswer;
  final List<Map<String, String>> options = [
    {'text': '12 tahun atau lebih muda', 'value': '12_or_younger'},
    {'text': '13 sampai 16 tahun', 'value': '13_to_16'},
    {'text': '17 sampai 24 tahun', 'value': '17_to_24'},
    {'text': '25 tahun atau lebih tua', 'value': '25_or_older'},
  ];

  void _selectAnswer(String value) {
    setState(() {
      selectedAnswer = value;
    });
  }

  void _continue() {
    if (selectedAnswer != null) {
      Navigator.pushNamed(context, '/question-2');
    }
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
                  widthFactor: 1 / 8, // Question 1 of 8
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // Question Label
              Text(
                'Pertanyaan 1',
                style: AppText.body.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppSpacing.medium),
              
              // Question Text
              Text(
                'Diumur berapa kamu menonton pornografi untuk pertama kalinya?',
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
                    final option = options[index];
                    final isSelected = selectedAnswer == option['value'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(option['value']!),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.large),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.textLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : AppTheme.textLight.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            option['text']!,
                            style: AppText.body.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? AppTheme.primary : AppTheme.textDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Continue Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: AppSpacing.medium),
                decoration: BoxDecoration(
                  gradient: selectedAnswer != null 
                      ? AppTheme.primaryGradient 
                      : LinearGradient(
                          colors: [
                            AppTheme.textLight.withOpacity(0.5),
                            AppTheme.textLight.withOpacity(0.5),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  boxShadow: selectedAnswer != null ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ] : [],
                ),
                child: ElevatedButton(
                  onPressed: selectedAnswer != null ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: selectedAnswer != null ? Colors.white : AppTheme.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
