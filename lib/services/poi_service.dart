import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/poi.dart';

class PoiService {
  PoiService._();

  static final PoiService instance = PoiService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _poisRef =>
      _firestore.collection('pois');

  Future<List<Poi>> getPois() async {
    final snapshot = await _poisRef
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Poi.fromJson(doc.data()))
        .toList();
  }

  Future<List<Poi>> getPoisByCategory(String category) async {
    final normalized = category.trim();
    if (normalized.isEmpty) {
      return getPois();
    }

    final snapshot = await _poisRef
        .where('category', isEqualTo: normalized.toLowerCase())
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Poi.fromJson(doc.data()))
        .toList();
  }

  Future<List<Poi>> getNearbyPois(
    double userLat,
    double userLng, {
    double radiusInKm = 5.0,
  }) async {
    final pois = await getPois();

    final nearby = pois.where((poi) {
      final distance = _distanceInKm(
        userLat,
        userLng,
        poi.latitude,
        poi.longitude,
      );
      return distance <= radiusInKm;
    }).toList();

    nearby.sort((a, b) {
      final distanceA = _distanceInKm(
        userLat,
        userLng,
        a.latitude,
        a.longitude,
      );
      final distanceB = _distanceInKm(
        userLat,
        userLng,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return nearby;
  }

  Stream<List<Poi>> getPoisStream() {
    return _poisRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Poi.fromJson(doc.data()))
            .toList());
  }

  Future<Poi?> getPoiById(String id) async {
    final doc = await _poisRef.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return Poi.fromJson(doc.data()!);
  }

  Future<void> addPoi(Poi poi) async {
    await _poisRef.doc(poi.id).set(poi.toJson());
  }

  Future<void> updatePoi(Poi poi) async {
    await _poisRef.doc(poi.id).update(poi.toJson());
  }

  Future<void> deletePoi(String id) async {
    await _poisRef.doc(id).delete();
  }

  double _distanceInKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371.0;

    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double value) {
    return value * math.pi / 180;
  }
}
