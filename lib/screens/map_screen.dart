import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mapBackground,
      child: const Center(
        child: Text(
          'Carte',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}