import 'package:flutter/material.dart';
import '../main.dart';

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Centro Universitario Regional de Cabañas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '© 2024 Raíces Digitales',
              style: TextStyle(
                color: AppColors.greenSoft,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
