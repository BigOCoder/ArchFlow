// lib/features/team/presentation/widgets/empty_team_illustration.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class EmptyTeamIllustration extends StatelessWidget {
  final bool isDark;

  const EmptyTeamIllustration({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),

          // Dotted Circle
          CustomPaint(
            size: const Size(200, 200),
            painter: DottedCirclePainter(
              color: AppColors.brandGreen.withOpacity(0.2),
            ),
          ),

          // People Icons
          Positioned(
            top: 40,
            child: _personIcon('👥', 0.3),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            child: _personIcon('👤', 0.25),
          ),
          Positioned(
            bottom: 50,
            right: 40,
            child: _personIcon('👤', 0.25),
          ),

          // Center Plus Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.brandGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandGreen.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.group_add,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _personIcon(String emoji, double opacity) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withOpacity(opacity)
            : AppColors.lightSurface.withOpacity(opacity),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandGreen.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final Color color;

  DottedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 8.0;
    double startAngle = 0;

    while (startAngle < 360) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
        _degreesToRadians(startAngle),
        _degreesToRadians(dashWidth),
        false,
        paint,
      );
      startAngle += dashWidth + dashSpace;
    }
  }

  double _degreesToRadians(double degrees) {
    return (degrees * 3.141592653589793) / 180.0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
