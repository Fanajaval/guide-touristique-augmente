import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import '../services/poi_service.dart';
import '../theme/app_theme.dart';

import '../data/mock_pois.dart';
import '../models/poi.dart';
import 'poi_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();

  IconData _getPoiIcon(String category) {
    final normalized = category
        .trim()
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ô', 'o')
        .replaceAll('à', 'a')
        .replaceAll('ç', 'c')
        .replaceAll(' ', '');

    switch (normalized) {
      case 'monument':
        return Icons.account_balance;

      case 'nature':
        return Icons.park;

      case 'musee':
        return Icons.museum;

      case 'marche':
        return Icons.storefront;

      case 'restaurant':
        return Icons.restaurant;

      case 'hotel':
        return Icons.hotel;

      default:
        return Icons.location_on;
    }
  }

  void _showPoiPreview(Poi poi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _PoiBottomSheet(poi: poi);
      },
    );
  }

  StreamSubscription<Position>? _positionSubscription;

  //position_utilisateur
  LatLng? _userPosition;

  bool _isLoadingLocation = true;
  List<Poi> _pois = [];

  //position si gps indispo
  final LatLng _initialPosition = const LatLng(-18.8792, 47.5079);

  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _loadPois();
    //recuperer position actuel
    _loadUserLocation();

    //ecoute déplacement_user
    _listenToLocation();
  }

  Future<void> _loadPois() async {
    try {
      final loadedPois = await PoiService.instance.getPois();

      if (!mounted) return;

      setState(() {
        _pois = loadedPois.isEmpty ? mockPois : loadedPois;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _pois = mockPois;
      });
    }
  }

  Future<void> _loadUserLocation() async {
    final position = await _locationService.getCurrentPosition();

    if (!mounted) return;

    if (position != null) {
      final userPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _userPosition = userPosition;
        _isLoadingLocation = false;
        _currentZoom = 15.0;
      });

      _mapController.move(userPosition, 15);
    } else {
      //gps indispo ou permission refusé
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  //suivi position user
  void _listenToLocation() {
    _positionSubscription = _locationService.getPositionStream().listen((
      position,
    ) {
      if (!mounted) return;

      setState(() {
        _userPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  void _zoomIn() {
    final center = _mapController.camera.center;

    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(5.0, 18.0);
    });

    _mapController.move(center, _currentZoom);
  }

  void _zoomOut() {
    final center = _mapController.camera.center;

    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(5.0, 18.0);
    });

    _mapController.move(center, _currentZoom);
  }

  void _recenterMap() {
    if (_userPosition == null) {
      return;
    }

    setState(() {
      _currentZoom = 15.0;
    });

    _mapController.move(_userPosition!, _currentZoom);
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
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.guide_touristique_augmente',
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
                        color: AppColors.primary.withValues(alpha: 0.15),
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

                //poi
                ..._pois.map(
                  (poi) => Marker(
                    point: LatLng(poi.latitude, poi.longitude),
                    width: 50,
                    height: 60,

                    child: GestureDetector(
                      onTap: () {
                        _showPoiPreview(poi);
                      },

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,

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

                            child: Icon(
                              _getPoiIcon(poi.category),
                              color: AppColors.white,
                              size: 22,
                            ),
                          ),

                          // Petite pointe sous le marqueur
                          CustomPaint(
                            size: const Size(12, 6),
                            painter: _MarkerPointerPainter(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Localisation en cours...'),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Positioned(top: 16, left: 16, right: 16, child: _buildSearchBar()),

        Positioned(right: 16, top: 100, child: _buildMapControls()),

        Positioned(left: 16, bottom: 90, child: _buildMapInfo()),
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

        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),

        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.primary),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                'Rechercher un lieu...',
                style: TextStyle(color: AppColors.grey, fontSize: 15),
              ),
            ),

            const Icon(Icons.tune, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        // Zoom +
        _MapButton(icon: Icons.add, onPressed: _zoomIn),

        const SizedBox(height: 8),

        //zoom
        _MapButton(icon: Icons.remove, onPressed: _zoomOut),

        const SizedBox(height: 8),

        //position actuel
        _MapButton(icon: Icons.my_location, onPressed: _recenterMap),
      ],
    );
  }

  //info carte
  Widget _buildMapInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

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
          Icon(Icons.explore, color: AppColors.accent, size: 20),

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

  const _MapButton({required this.icon, required this.onPressed});

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

          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
      ),
    );
  }
}

class _PoiBottomSheet extends StatelessWidget {
  final Poi poi;

  const _PoiBottomSheet({required this.poi});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),

      padding: const EdgeInsets.all(16),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,

                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),
            //image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),

              child: poi.displayImage.startsWith('http')
                  ? Image.network(
                      poi.displayImage,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      poi.displayImage.isEmpty
                          ? 'assets/images/pois/rova.jpg'
                          : poi.displayImage,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),
            //categorie
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                poi.category,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 10),
            //note+nom
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: Text(
                    poi.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.accent, size: 20),

                    const SizedBox(width: 4),

                    Text(
                      poi.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
            //adresse
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    poi.address,
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            //description
            Text(
              poi.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(color: AppColors.grey, height: 1.4),
            ),

            const SizedBox(height: 18),
            //bouton
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoiDetailScreen(poi: poi),
                    ),
                  );
                },

                icon: const Icon(Icons.explore),

                label: const Text('Explorer ce lieu'),

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkerPointerPainter extends CustomPainter {
  final Color color;

  _MarkerPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = ui.Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerPointerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
