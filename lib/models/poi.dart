class Poi {
  final String id;
  final String name;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final String imagePath;
  final String address;
  final double rating;

  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.address,
    required this.rating,
  });
}