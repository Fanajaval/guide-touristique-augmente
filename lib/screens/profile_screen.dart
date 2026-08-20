import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // titre
              const Text(
                'Mon profil',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              //carte profil
              _buildProfileCard(),

              const SizedBox(height: 28),

              //mon activité
              const Text(
                'Mon activité',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _ProfileMenuItem(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.accent,
                title: 'Mes favoris',
                subtitle: 'Retrouvez vos lieux préférés',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              //application
              const SizedBox(height: 18),

              const Text(
                'Application',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                iconColor: AppColors.primary,
                title: 'Paramètres',
                subtitle: 'Personnalisez votre expérience',
                onTap: () {
                  // Écran paramètres à ajouter plus tard.
                },
              ),

              const SizedBox(height: 10),

              _ProfileMenuItem(
                icon: Icons.notifications_none_rounded,
                iconColor: AppColors.primary,
                title: 'Notifications',
                subtitle: 'Gérez vos notifications',
                onTap: () {
                  // Gestion des notifications à ajouter plus tard.
                },
              ),

              const SizedBox(height: 28),

              //info
              const Text(
                'Informations',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _ProfileMenuItem(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.primary,
                title: 'À propos de MadaGuide',
                subtitle: 'Découvrez l’application',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),

              const SizedBox(height: 28),

              //deconnexion
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  //carte profil

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // Avatar temporaire
          Container(
            width: 72,
            height: 72,

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.20),
                width: 2,
              ),
            ),

            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 38,
            ),
          ),

          const SizedBox(width: 16),

          //info temporaires
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Utilisateur',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Bienvenue sur MadaGuide',
                  style: TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          //btn modifier
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  //btn deconnexion
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: OutlinedButton.icon(
        onPressed: () {
          // Déconnexion Firebase à ajouter plus tard.
        },

        icon: const Icon(Icons.logout_rounded, color: AppColors.error),

        label: const Text(
          'Se déconnecter',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.35)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  //about
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MadaGuide',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.explore_rounded,
        color: AppColors.primary,
        size: 36,
      ),
      children: const [
        Text(
          'MadaGuide est une application mobile '
          'destinée à faciliter la découverte des '
          'lieux touristiques de Madagascar.',
        ),
      ],
    );
  }
}

//élément menu profil
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              // Icône
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: iconColor, size: 22),
              ),

              const SizedBox(width: 14),

              //texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.grey,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
