import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();

  StreamSubscription<Position>? _positionSubscription;

  //position_utilisateur
  LatLng? _userPosition;

  bool _isLoadingLocation = true;

  //position si gps indispo
  final LatLng _initialPosition = const LatLng(
    -18.8792,
    47.5079,
  );

  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    //recuperer position actuel
    _loadUserLocation();

    //ecoute déplacement_user
    _listenToLocation();
  }

  Future<void> _loadUserLocation() async {
    final position = await _locationService.getCurrentPosition();

    if (!mounted) return;

    if (position != null) {
      final userPosition = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _userPosition = userPosition;
        _isLoadingLocation = false;
      });
      
      _mapController.move(
        userPosition,
        15,
      );

      setState(() {
        _currentZoom = 15.0;
      });
    } else {
      //gps indispo ou permission refusé
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }
//suivi position user
  void _listenToLocation() {
    _positionSubscription =
        _locationService.getPositionStream().listen(
      (position) {
        if (!mounted) return;

        setState(() {
          _userPosition = LatLng(
            position.latitude,
            position.longitude,
          );
        });
      },
    );
  }

  void _zoomIn() {
    final center = _mapController.camera.center;

    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(5.0, 18.0);
    });

    _mapController.move(
      center,
      _currentZoom,
    );
  }

  void _zoomOut() {
    final center = _mapController.camera.center;

    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(5.0, 18.0);
    });

    _mapController.move(
      center,
      _currentZoom,
    );
  }

  void _recenterMap() {
    if (_userPosition == null) {
      return;
    }

    setState(() {
      _currentZoom = 15.0;
    });

    _mapController.move(
      _userPosition!,
      _currentZoom,
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController.dispose();

    super.dispose();
  }

  //interface
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //carte
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
 
          //position utilisateur
            MarkerLayer(
              markers: [
                if (_userPosition != null)
                  Marker(
                    point: _userPosition!,
                    width: 56,
                    height: 56,

                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        shape: BoxShape.circle,
                      ),

                      child: Center(
                        child: Container(
                          width: 22,
                          height: 22,

                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,

                            border: Border.all(
                              color: AppColors.white,
                              width: 3,
                            ),

                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),

        if (_isLoadingLocation)
          const Positioned(
            top: 85,
            left: 0,
            right: 0,
            child: Center(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Localisation en cours...',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: _buildSearchBar(),
        ),

        Positioned(
          right: 16,
          top: 100,
          child: _buildMapControls(),
        ),

        Positioned(
          left: 16,
          bottom: 90,
          child: _buildMapInfo(),
        ),
      ],
    );
  }

  //barre de recherche
  Widget _buildSearchBar() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(24),

      child: Container(
        height: 52,

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

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
        // Zoom +
        _MapButton(
          icon: Icons.add,
          onPressed: _zoomIn,
        ),

        const SizedBox(height: 8),

        //zoom
        _MapButton(
          icon: Icons.remove,
          onPressed: _zoomOut,
        ),

        const SizedBox(height: 8),

        //position actuel
        _MapButton(
          icon: Icons.my_location,
          onPressed: _recenterMap,
        ),
      ],
    );
  }

//info carte
  Widget _buildMapInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: AppColors.white.withValues(
          alpha: 0.95,
        ),

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

//botton
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