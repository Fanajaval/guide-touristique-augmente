import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/poi.dart';

class FavoritesService {
  FavoritesService._();

  static final FavoritesService instance = FavoritesService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Poi> _favorites = [];

  List<Poi> get favorites => List.unmodifiable(_favorites);

  Future<List<Poi>> loadFavorites() async {
    try {
      final userId = await _ensureUserId();
      if (userId == null) {
        _favorites.clear();
        return const [];
      }

      final snapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();

      final loadedFavorites = snapshot.docs
          .map((doc) {
            final poiData = doc.data()['poi'];
            if (poiData is! Map<String, dynamic>) {
              return null;
            }
            return Poi.fromJson(Map<String, dynamic>.from(poiData));
          })
          .whereType<Poi>()
          .toList();

      _favorites
        ..clear()
        ..addAll(loadedFavorites);

      return List.unmodifiable(_favorites);
    } catch (_) {
      _favorites.clear();
      rethrow;
    }
  }

  Future<bool> isFavorite(Poi poi) async {
    try {
      final userId = await _ensureUserId();
      if (userId == null) {
        return false;
      }

      final doc = await _firestore
          .collection('favorites')
          .doc('${userId}_${poi.id}')
          .get();

      return doc.exists;
    } catch (_) {
      return _favorites.any((favorite) => favorite.id == poi.id);
    }
  }

  Future<void> toggleFavorite(Poi poi) async {
    try {
      final alreadyFavorite = await isFavorite(poi);
      if (alreadyFavorite) {
        await removeFavorite(poi);
      } else {
        await addFavorite(poi);
      }

      await loadFavorites();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addFavorite(Poi poi) async {
    final currentUser = _auth.currentUser;
    final resolvedUserId = currentUser?.uid ?? await _ensureUserId();
    if (resolvedUserId == null || poi.id.isEmpty) {
      return;
    }

    await _saveFavoriteToFirestore(poi, resolvedUserId);
  }

  Future<void> removeFavorite(Poi poi) async {
    final currentUser = _auth.currentUser;
    final resolvedUserId = currentUser?.uid ?? await _ensureUserId();
    if (resolvedUserId == null || poi.id.isEmpty) {
      return;
    }

    await _deleteFavoriteFromFirestore(poi.id, resolvedUserId);
  }

  Future<void> clearFavorites() async {
    final userId = await _ensureUserId();
    if (userId == null) {
      _favorites.clear();
      return;
    }

    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    _favorites.clear();
  }

  Future<String?> _ensureUserId() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }

    final credential = await _auth.signInAnonymously();
    return credential.user?.uid;
  }

  Future<void> _saveFavoriteToFirestore(Poi poi, [String? userId]) async {
    final resolvedUserId = userId ?? await _ensureUserId();
    if (resolvedUserId == null) {
      return;
    }

    await _firestore.collection('favorites').doc('${resolvedUserId}_${poi.id}').set({
      'userId': resolvedUserId,
      'poiId': poi.id,
      'poi': poi.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteFavoriteFromFirestore(String poiId, [String? userId]) async {
    final resolvedUserId = userId ?? await _ensureUserId();
    if (resolvedUserId == null) {
      return;
    }

    await _firestore.collection('favorites').doc('${resolvedUserId}_$poiId').delete();
  }
}