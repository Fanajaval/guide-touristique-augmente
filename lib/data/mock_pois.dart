import '../models/poi.dart';

const List<Poi> mockPois = [
  Poi(
    id: 'poi_001',
    name: 'Rova de Manjakamiadana',
    category: 'Monument',
    description:
        'Le Rova de Manjakamiadana est un site historique emblématique d’Antananarivo.',
    latitude: -18.9219,
    longitude: 47.5327,
    imagePath: 'assets/images/pois/rova.jpg',
    address: 'Antananarivo, Madagascar',
    rating: 4.8,
  ),

  Poi(
    id: 'poi_002',
    name: 'Lac Anosy',
    category: 'Nature',
    description:
        'Un lieu agréable au cœur d’Antananarivo, reconnaissable à son monument et ses jacarandas.',
    latitude: -18.9146,
    longitude: 47.5213,
    imagePath: 'assets/images/pois/lac_anosy.jpg',
    address: 'Lac Anosy, Antananarivo',
    rating: 4.5,
  ),

  Poi(
    id: 'poi_003',
    name: 'Musée de la Photographie',
    category: 'Musée',
    description:
        'Un espace consacré à l’histoire et au patrimoine photographique de Madagascar.',
    latitude: -18.9140,
    longitude: 47.5310,
    imagePath: 'assets/images/pois/musee_photographie.jpg',
    address: 'Antananarivo, Madagascar',
    rating: 4.6,
  ),

  Poi(
    id: 'poi_004',
    name: 'Parc de Tsimbazaza',
    category: 'Nature',
    description:
        'Un parc zoologique et botanique permettant de découvrir une partie de la biodiversité malgache.',
    latitude: -18.9307,
    longitude: 47.5189,
    imagePath: 'assets/images/pois/tsimbazaza.jpg',
    address: 'Tsimbazaza, Antananarivo',
    rating: 4.4,
  ),

  Poi(
    id: 'poi_005',
    name: 'Marché d’Analakely',
    category: 'Marché',
    description:
        'Un marché animé permettant de découvrir la vie quotidienne et les produits locaux.',
    latitude: -18.9057,
    longitude: 47.5248,
    imagePath: 'assets/images/pois/analakely.jpg',
    address: 'Analakely, Antananarivo',
    rating: 4.3,
  ),
];