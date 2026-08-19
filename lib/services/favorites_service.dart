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

  Future<void> loadFavorites() async {
    try {
      final userId = await _ensureUserId();
      if (userId == null) {
        _favorites.clear();
        return;
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
    } catch (_) {
      _favorites.clear();
      rethrow;
    }
  }

  bool isFavorite(Poi poi) {
    return _favorites.any(
      (favorite) => favorite.id == poi.id,
    );
  }

  Future<void> toggleFavorite(Poi poi) async {
    try {
      if (isFavorite(poi)) {
        await removeFavorite(poi);
      } else {
        await addFavorite(poi);
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addFavorite(Poi poi) async {
    if (isFavorite(poi)) {
      return;
    }

    try {
      _favorites.add(poi);
      await _saveFavoriteToFirestore(poi);
    } catch (_) {
      _favorites.removeWhere((favorite) => favorite.id == poi.id);
      rethrow;
    }
  }

  Future<void> removeFavorite(Poi poi) async {
    try {
      _favorites.removeWhere((favorite) => favorite.id == poi.id);
      await _deleteFavoriteFromFirestore(poi.id);
    } catch (_) {
      rethrow;
    }
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

  Future<void> _saveFavoriteToFirestore(Poi poi) async {
    final userId = await _ensureUserId();
    if (userId == null) {
      return;
    }

    await _firestore.collection('favorites').doc('${userId}_${poi.id}').set({
      'userId': userId,
      'poiId': poi.id,
      'poi': poi.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteFavoriteFromFirestore(String poiId) async {
    final userId = await _ensureUserId();
    if (userId == null) {
      return;
    }

    await _firestore.collection('favorites').doc('${userId}_$poiId').delete();
  }
}