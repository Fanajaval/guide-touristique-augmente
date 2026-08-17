import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Position temporaire pour les tests.
  // Elle sera remplacée par la position GPS réelle.
  final LatLng _initialPosition = const LatLng(
    -18.8792,
    47.5079,
  );

  double _currentZoom = 13.0;

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
    });

    _mapController.move(
      _initialPosition,
      _currentZoom,
    );
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
    });

    _mapController.move(
      _initialPosition,
      _currentZoom,
    );
  }

  void _recenterMap() {
    _mapController.move(
      _initialPosition,
      _currentZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─────────────────────────────────────
        // CARTE
        // ─────────────────────────────────────
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialPosition,
            initialZoom: _currentZoom,
            minZoom: 5,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName:
                  'com.example.guide_touristique_augmente',
            ),

            // Marqueur temporaire
            MarkerLayer(
              markers: [
                Marker(
                  point: _initialPosition,
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ─────────────────────────────────────
        // BARRE DE RECHERCHE
        // ─────────────────────────────────────
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: _buildSearchBar(),
        ),

        // ─────────────────────────────────────
        // CONTRÔLES DE LA CARTE
        // ─────────────────────────────────────
        Positioned(
          right: 16,
          top: 100,
          child: _buildMapControls(),
        ),

        // ─────────────────────────────────────
        // INFORMATIONS MADA GUIDE
        // ─────────────────────────────────────
        Positioned(
          left: 16,
          bottom: 90,
          child: _buildMapInfo(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Rechercher un lieu...',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(
              Icons.tune,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        _MapButton(
          icon: Icons.add,
          onPressed: _zoomIn,
        ),
        const SizedBox(height: 8),
        _MapButton(
          icon: Icons.remove,
          onPressed: _zoomOut,
        ),
        const SizedBox(height: 8),
        _MapButton(
          icon: Icons.my_location,
          onPressed: _recenterMap,
        ),
      ],
    );
  }

  Widget _buildMapInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore,
            color: AppColors.accent,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Explorez autour de vous',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      color: AppColors.white,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}