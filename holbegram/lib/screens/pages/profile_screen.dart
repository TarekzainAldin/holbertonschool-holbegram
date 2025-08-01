import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/login_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('No user logged in'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Titre du profil
            const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            // Bouton de déconnexion
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(child: Text('Error loading profile'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          // Récupération des statistiques utilisateur
          final posts = userData['posts'] as List<dynamic>? ?? [];
          final followers = userData['followers'] as List<dynamic>? ?? [];
          final following = userData['following'] as List<dynamic>? ?? [];
          final profileImage = userData['photoUrl'] as String? ?? '';

          return Column(
            children: [
              // Header du profil
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Avatar utilisateur
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    // Statistiques utilisateur
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('posts', posts.length),
                          _buildStatColumn('followers', followers.length),
                          _buildStatColumn('following', following.length),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Section pour afficher les posts
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Nombre de colonnes
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1, // Carré
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final postUrl = posts[index] as String? ?? '';
                    return postUrl.isNotEmpty
                        ? Image.network(postUrl, fit: BoxFit.cover)
                        : Container(color: Colors.grey[300]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Fonction pour afficher les statistiques utilisateur
  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Exemple de fonction de déconnexion
  void logout(BuildContext context) async {
    /*try {
      // Déconnexion de l'utilisateur
      await FirebaseAuth.instance.signOut();

      // Redirection vers la page LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Supprime toutes les routes précédentes
      );
    } catch (e) {
      // Affiche un message d'erreur en cas de problème
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }*/
  }
}