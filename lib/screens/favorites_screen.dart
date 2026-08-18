import 'package:flutter/material.dart';

import '../models/poi.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import 'poi_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService.instance;

  List<Poi> get _favorites => _favoritesService.favorites;

  void _removeFavorite(Poi poi) {
    setState(() {
      _favoritesService.removeFavorite(poi);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${poi.name} retiré des favoris',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openPoiDetail(Poi poi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoiDetailScreen(
          poi: poi,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  10,
                ),
                child: _buildHeader(),
              ),
            ),

            if (_favorites.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  100,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final poi = _favorites[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: _FavoritePoiCard(
                          poi: poi,
                          onTap: () => _openPoiDetail(poi),
                          onRemove: () => _removeFavorite(poi),
                        ),
                      );
                    },
                    childCount: _favorites.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mes favoris',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          _favorites.isEmpty
              ? 'Les lieux que vous aimez apparaîtront ici.'
              : '${_favorites.length} lieu${_favorites.length > 1 ? 'x' : ''} enregistré${_favorites.length > 1 ? 's' : ''}',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                color: AppColors.accent,
                size: 44,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Aucun favori pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Explorez les lieux touristiques et '
              'enregistrez ceux que vous souhaitez '
              'retrouver facilement.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.explore_outlined,
              ),
              label: const Text(
                'Explorer les lieux',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritePoiCard extends StatelessWidget {
  final Poi poi;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoritePoiCard({
    required this.poi,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 125,
          child: Row(
            children: [
              _buildImage(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    12,
                    8,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildCategory(),

                      const SizedBox(height: 6),

                      Text(
                        poi.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.accent,
                            size: 17,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            poi.rating.toString(),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 16,
                          ),

                          const SizedBox(width: 3),

                          Expanded(
                            child: Text(
                              poi.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              IconButton(
                onPressed: onRemove,
                tooltip: 'Retirer des favoris',
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 120,
      height: double.infinity,
      child: Image.asset(
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
                color: AppColors.grey,
                size: 36,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        poi.category,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}