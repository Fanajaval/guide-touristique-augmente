# MadaGuide

MadaGuide est une application mobile Flutter dédiée à la découverte touristique de Madagascar. Elle permet à l’utilisateur d’explorer des lieux emblématiques, de les localiser sur une carte interactive, de filtrer les points d’intérêt par catégorie et de sauvegarder ses favoris pour organiser un voyage ou une visite locale.

## Présentation

Le projet a pour objectif de rendre la découverte du patrimoine, de la nature et des villes malgaches plus simple et plus immersive. L’application combine :

- une carte interactive,
- une recherche de lieux,
- une liste de points d’intérêt,
- une gestion des favoris,
- un système d’authentification Firebase,
- un profil utilisateur avec paramètres et informations.

## Fonctionnalités

### 1. Exploration des lieux
- Recherche textuelle par nom ou adresse.
- Filtres par catégorie : Monument, Nature, Musée, Marché, Restaurant, Hôtel.
- Liste des points d’intérêt avec visuels et informations essentielles.

### 2. Carte interactive
- Affichage des points d’intérêt sur une carte via Flutter Map.
- Localisation de l’utilisateur avec Geolocator.
- Recherche de lieux via l’API OpenStreetMap Nominatim.
- Calcul d’itinéraire vers une destination sélectionnée.

### 3. Fiche détaillée d’un lieu
- Description du site,
- adresse,
- catégorie,
- image,
- note / appréciation,
- possibilité d’ajouter ou retirer un lieu aux favoris.

### 4. Favoris utilisateur
- Enregistrement des lieux préférés dans Firestore.
- Accès rapide à la liste des favoris depuis l’application.
- Chargement automatique des données utilisateur après connexion.

### 5. Authentification
- Connexion / inscription via Firebase Authentication.
- Gestion des erreurs de connexion et d’inscription.
- Redirection automatique selon l’état de connexion.

### 6. Profil
- Affichage du profil utilisateur,
- accès aux favoris,
- paramètres et notifications,
- à propos de l’application,
- déconnexion.

## Stack technique

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Flutter Map
- Geolocator
- HTTP + Nominatim OpenStreetMap
- Google Fonts

## Prérequis

Avant de lancer le projet, assurez-vous d’avoir installé :

- Flutter SDK 3.12 ou supérieur
- Dart SDK compatible
- Android Studio ou VS Code avec le SDK Flutter
- Un émulateur Android ou un appareil connecté
- Un projet Firebase configuré

## Installation

1. Clonez le dépôt :

```bash
git clone <url-du-repo>
cd guide_touristique_augmente
```

2. Installez les dépendances :

```bash
flutter pub get
```

3. Configurez Firebase :

- Créez un projet Firebase,
- activez Authentication et Firestore,
- ajoutez les plateformes Android/iOS/Web selon votre besoin,
- téléchargez les fichiers de configuration Firebase,
- vérifiez que le fichier `lib/firebase_options.dart` est bien présent et cohérent.

4. Si nécessaire, générez les fichiers Firebase pour Flutter :

```bash
flutterfire configure
```

## Lancement du projet

Pour démarrer l’application en mode développement :

```bash
flutter run
```

Pour cibler un appareil spécifique :

```bash
flutter devices
flutter run -d <device_id>
```

## Build APK

Pour générer une version Android :

```bash
flutter build apk --split-per-abi
```

Pour générer un bundle Android :

```bash
flutter build appbundle
```

## Structure du projet

```text
lib/
  data/               # Données de démonstration et points d’intérêt
  models/             # Modèles de données (ex. Poi)
  screens/            # Écrans de l’application
  services/           # Auth, favoris, géolocalisation, POI
  theme/              # Palette et thème visuel
  widgets/            # Widgets réutilisables
  main.dart           # Point d’entrée
assets/
  images/pois/        # Images des POIs
android/              # Projet Android
ios/                  # Projet iOS
web/                  # Projet Web
linux/                # Projet Linux
macos/                # Projet macOS
windows/              # Projet Windows
test/                 # Tests
```

## Données de démonstration

Le projet contient un jeu de données local dans [lib/data/mock_pois.dart](lib/data/mock_pois.dart). Ces données servent de fallback en cas d’indisponibilité de Firestore ou lors des premiers tests du projet.

## État du projet

Le projet est structuré comme une application mobile de type guide touristique, avec une orientation orientée utilisateur, localisation, découverte et personnalisation des favoris. Il est bien adapté à un contexte de démonstration, de projet académique ou de prototype fonctionnel.

## Remarques

- L’application supporte la connexion Firebase ainsi que la gestion des favoris.
- La carte est centrée sur la localisation GPS si elle est disponible, sinon elle utilise une position de secours à Madagascar.
- Les données peuvent être enrichies pour couvrir davantage de lieux ou améliorer la qualité des contenus.

## Licence

Ce projet est fourni à des fins de développement et de démonstration. Avant toute mise en production ou diffusion publique, vérifiez les droits d’usage et les règles de publication applicables.
