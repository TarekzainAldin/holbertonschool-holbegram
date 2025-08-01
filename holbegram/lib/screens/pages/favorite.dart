import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/post.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Favorites',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        // Stream pour écouter les posts ajoutés aux favoris par l'utilisateur
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('likes',
                arrayContains: currentUserUid) // Filtrer les favoris
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return const Center(
              child: Text('No favorite post found.'),
            );
          }

          final favoritePosts =
              data.map((doc) => Post.fromSnapshot(doc)).toList();

          return ListView.builder(
            itemCount: favoritePosts.length,
            itemBuilder: (context, index) {
              final post = favoritePosts[index];

              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    // Image du post
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(post.postUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Caption du post
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        post.caption,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}