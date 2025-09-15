import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section with light blue background
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  // Large light blue circle background
                  Positioned(
                    top: 80,
                    left: -50,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBBDEFB).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Title
                  const Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Text(
                      'NADI PARIKSHA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2E7D32),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  // Pink heart with heartbeat line
                  Positioned(
                    left: 30,
                    top: 140,
                    child: Container(
                      width: 100,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE91E63),
                      ),
                      child: CustomPaint(
                        painter: HeartPainter(),
                      ),
                    ),
                  ),
                  // Heartbeat line
                  Positioned(
                    left: 80,
                    top: 190,
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CustomPaint(
                        painter: HeartbeatLinePainter(),
                      ),
                    ),
                  ),
                  // Green leaves
                  Positioned(
                    left: 140,
                    top: 120,
                    child: Transform.rotate(
                      angle: -0.3,
                      child: Container(
                        width: 60,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                        ),
                        child: CustomPaint(
                          painter: LeafPainter(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 180,
                    top: 140,
                    child: Transform.rotate(
                      angle: 0.2,
                      child: Container(
                        width: 50,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Color(0xFF66BB6A),
                        ),
                        child: CustomPaint(
                          painter: LeafPainter(),
                        ),
                      ),
                    ),
                  ),
                  // Doctor figure on right
                  Positioned(
                    right: 30,
                    top: 130,
                    child: Container(
                      width: 80,
                      height: 140,
                      child: CustomPaint(
                        painter: DoctorPainter(),
                      ),
                    ),
                  ),
                  // Medical checklist card (center)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 180,
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE91E63),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'MEDICAL\nCHECK-UP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildChecklistItem(),
                                    _buildChecklistItem(),
                                    _buildChecklistItem(),
                                    _buildChecklistItem(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Blue cylinder on left
                  Positioned(
                    left: 15,
                    bottom: 80,
                    child: Container(
                      width: 35,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  // Pink woman figure on right
                  Positioned(
                    right: 15,
                    bottom: 60,
                    child: Container(
                      width: 60,
                      height: 120,
                      child: CustomPaint(
                        painter: WomanPainter(),
                      ),
                    ),
                  ),
                  // Purple phone base
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9C27B0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom section with teal background
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF4DB6AC),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Container(
                      width: 260,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CustomPaint(
                              painter: GoogleLogoPainter(),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            'Google',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'The statement by continue I hereby accept the\nTerms and service and privacy policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem() {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 12,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.8);
    path.cubicTo(size.width * 0.2, size.height * 0.4, size.width * 0.1, size.height * 0.1, size.width * 0.3, size.height * 0.2);
    path.cubicTo(size.width * 0.4, size.height * 0.05, size.width * 0.6, size.height * 0.05, size.width * 0.7, size.height * 0.2);
    path.cubicTo(size.width * 0.9, size.height * 0.1, size.width * 0.8, size.height * 0.4, size.width * 0.5, size.height * 0.8);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeartbeatLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE91E63)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.3, size.height * 0.2);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.7);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width * 0.9, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width * 0.5, size.height);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.9, size.width * 0.1, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.5, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DoctorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Head
    paint.color = const Color(0xFFFFCC80);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), size.width * 0.25, paint);

    // Hair
    paint.color = const Color(0xFF3E2723);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.15), size.width * 0.28, paint);

    // White coat
    paint.color = Colors.white;
    final coatRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.35, size.width * 0.6, size.height * 0.5),
      const Radius.circular(10),
    );
    canvas.drawRRect(coatRect, paint);

    // Green tie/shirt
    paint.color = const Color(0xFF4CAF50);
    final tieRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.4, size.height * 0.35, size.width * 0.2, size.height * 0.3),
      const Radius.circular(5),
    );
    canvas.drawRRect(tieRect, paint);

    // Stethoscope
    paint.color = const Color(0xFF4CAF50);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    final stethPath = Path();
    stethPath.moveTo(size.width * 0.3, size.height * 0.4);
    stethPath.quadraticBezierTo(size.width * 0.1, size.height * 0.5, size.width * 0.15, size.height * 0.7);
    canvas.drawPath(stethPath, paint);
    
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.7), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WomanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Head
    paint.color = const Color(0xFFFFCC80);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), size.width * 0.2, paint);

    // Hair
    paint.color = const Color(0xFF3E2723);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.15), size.width * 0.22, paint);

    // Pink top
    paint.color = const Color(0xFFE91E63);
    final topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.25),
      const Radius.circular(8),
    );
    canvas.drawRRect(topRect, paint);

    // Black skirt
    paint.color = Colors.black87;
    final skirtPath = Path();
    skirtPath.moveTo(size.width * 0.3, size.height * 0.55);
    skirtPath.lineTo(size.width * 0.7, size.height * 0.55);
    skirtPath.lineTo(size.width * 0.8, size.height * 0.9);
    skirtPath.lineTo(size.width * 0.2, size.height * 0.9);
    skirtPath.close();
    canvas.drawPath(skirtPath, paint);

    // Shoes
    paint.color = const Color(0xFFE91E63);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.15, size.height * 0.9, size.width * 0.25, size.height * 0.08), paint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.6, size.height * 0.9, size.width * 0.25, size.height * 0.08), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Google G colors
    paint.color = const Color(0xFF4285F4);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.4, paint);
    
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.25, paint);
    
    paint.color = const Color(0xFF4285F4);
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.35, size.height * 0.3));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}