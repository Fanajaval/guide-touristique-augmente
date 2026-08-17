import 'package:flutter/material.dart';

import '../models/poi.dart';
import '../theme/app_theme.dart';

class PoiDetailScreen extends StatelessWidget {
  final Poi poi;

  const PoiDetailScreen({
    super.key,
    required this.poi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [
          //image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,

            backgroundColor: AppColors.primary,

            iconTheme: const IconThemeData(
              color: AppColors.white,
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                poi.imagePath,
                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: AppColors.background,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          //contenu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  //categorie
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      poi.category,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  //nom+note
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          poi.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),

                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.accent,
                              size: 18,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              poi.rating.toString(),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  //adresse
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 21,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          poi.address,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  //description
                  const Text(
                    'À propos de ce lieu',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    poi.description,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  //info
                  const Text(
                    'Informations pratiques',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _InfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Localisation',
                    value: poi.address,
                  ),

                  const SizedBox(height: 10),

                  _InfoCard(
                    icon: Icons.category_outlined,
                    title: 'Catégorie',
                    value: poi.category,
                  ),

                  const SizedBox(height: 10),

                  _InfoCard(
                    icon: Icons.star_outline,
                    title: 'Note',
                    value: '${poi.rating} / 5',
                  ),

                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 54,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        

                      },

                      icon: const Icon(
                        Icons.directions,
                      ),

                      label: const Text(
                        'Y aller',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.white,

                        elevation: 3,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//carte d'info
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}