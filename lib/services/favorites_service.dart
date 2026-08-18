import '../models/poi.dart';

class FavoritesService {
  FavoritesService._();

  static final FavoritesService instance = FavoritesService._();

  final List<Poi> _favorites = [];

  List<Poi> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Poi poi) {
    return _favorites.any(
      (favorite) => favorite.id == poi.id,
    );
  }

  void toggleFavorite(Poi poi) {
    if (isFavorite(poi)) {
      _favorites.removeWhere(
        (favorite) => favorite.id == poi.id,
      );
    } else {
      _favorites.add(poi);
    }
  }

  void addFavorite(Poi poi) {
    if (!isFavorite(poi)) {
      _favorites.add(poi);
    }
  }

  void removeFavorite(Poi poi) {
    _favorites.removeWhere(
      (favorite) => favorite.id == poi.id,
    );
  }

  void clearFavorites() {
    _favorites.clear();
  }
}