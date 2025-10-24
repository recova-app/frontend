import 'package:flutter/material.dart';

class SetVictoryLetterPage extends StatefulWidget {
  const SetVictoryLetterPage({super.key});

  @override
  State<SetVictoryLetterPage> createState() => _SetVictoryLetterPageState();
}

class _SetVictoryLetterPageState extends State<SetVictoryLetterPage> {
  int selectedGoal = 1; // Default to "1 day (recommended)"
  final List<Map<String, dynamic>> goals = [
    {'text': '12 hours', 'value': 0.5, 'recommended': false},
    {'text': '1 day (recommended)', 'value': 1, 'recommended': true},
    {'text': '3 days', 'value': 3, 'recommended': false},
  ];

  void _setGoal() {
    // Navigate to next page or handle goal setting
    Navigator.pushNamed(context, '/next-onboarding-step');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Status Bar Space
              const SizedBox(height: 20),
              
              // Main Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brain Character with Bow and Target
                    Container(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Brain Character
                          Positioned(
                            left: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Brain body
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB39DDB),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Brain texture lines
                                      Positioned(
                                        top: 15,
                                        left: 20,
                                        child: Container(
                                          width: 30,
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF9575CD),
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        right: 15,
                                        child: Container(
                                          width: 25,
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF9575CD),
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                        ),
                                      ),
                                      // Eyes
                                      Positioned(
                                        top: 25,
                                        left: 25,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 25,
                                        right: 30,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      // Mouth
                                      Positioned(
                                        bottom: 15,
                                        left: 35,
                                        child: Container(
                                          width: 30,
                                          height: 15,
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Arms holding bow
                                Positioned(
                                  left: -10,
                                  top: 30,
                                  child: Container(
                                    width: 20,
                                    height: 3,
                                    color: const Color(0xFF9575CD),
                                  ),
                                ),
                                Positioned(
                                  right: -15,
                                  top: 35,
                                  child: Container(
                                    width: 25,
                                    height: 3,
                                    color: const Color(0xFF9575CD),
                                  ),
                                ),
                                // Legs
                                Positioned(
                                  bottom: -15,
                                  left: 30,
                                  child: Container(
                                    width: 3,
                                    height: 20,
                                    color: const Color(0xFF9575CD),
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  right: 30,
                                  child: Container(
                                    width: 3,
                                    height: 20,
                                    color: const Color(0xFF9575CD),
                                  ),
                                ),
                                // Feet
                                Positioned(
                                  bottom: -15,
                                  left: 25,
                                  child: Container(
                                    width: 12,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9575CD),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  right: 25,
                                  child: Container(
                                    width: 12,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9575CD),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Bow
                          Positioned(
                            left: 120,
                            top: 70,
                            child: Container(
                              width: 40,
                              height: 60,
                              child: CustomPaint(
                                painter: BowPainter(),
                              ),
                            ),
                          ),
                          
                          // Arrow
                          Positioned(
                            left: 150,
                            top: 95,
                            child: Container(
                              width: 80,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                          
                          // Target
                          Positioned(
                            right: 30,
                            top: 70,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.brown.shade700, width: 2),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Target stand legs
                          Positioned(
                            right: 50,
                            bottom: 20,
                            child: Container(
                              width: 3,
                              height: 25,
                              color: Colors.brown.shade700,
                            ),
                          ),
                          Positioned(
                            right: 70,
                            bottom: 20,
                            child: Container(
                              width: 3,
                              height: 25,
                              color: Colors.brown.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Title
                    const Text(
                      'Porn-free victory goal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7E57C2), // Purple
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Main instruction
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Let\'s start with a small goal\nto build momentum.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          height: 1.2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                  ],
                ),
              ),
              
              // Goal Options
              Column(
                children: goals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final goal = entry.value;
                  final isSelected = selectedGoal == index;
                  final isRecommended = goal['recommended'] as bool;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGoal = index;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF3E5F5) : Colors.transparent,
                          border: Border(
                            top: index == 0 ? const BorderSide(color: Color(0xFFE0E0E0)) : BorderSide.none,
                            bottom: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            goal['text'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF7E57C2) : (isRecommended ? const Color(0xFF9E9E9E) : const Color(0xFF424242)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 40),
              
              // Bottom Buttons
              Column(
                children: [
                  // Set Goal Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7E57C2), Color(0xFF9C27B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ElevatedButton(
                      onPressed: _setGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Set porn-free goal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.shade700
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 4, size.width, 0);
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height * 3 / 4, size.width, size.height);
    
    // Bow string
    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
