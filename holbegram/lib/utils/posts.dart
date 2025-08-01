import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart'; // Importer le modèle Post
//import 'package:provider/provider.dart';
//import '../providers/user_provider.dart';
import '../screens/Pages/methods/post_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Future<void> toggleLike(Post post) async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(post.postId);

    try {
      if (post.likes.contains(currentUserUid)) {
        // Si déjà liké, retirer le like
        await postRef.update({
          'likes': FieldValue.arrayRemove([currentUserUid]),
        });
      } else {
        // Sinon, ajouter le like
        await postRef.update({
          'likes': FieldValue.arrayUnion([currentUserUid]),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser Provider pour obtenir les détails de l'utilisateur actuel
    //final userProvider = Provider.of<UserProvider>(context);
    //final currentUser = userProvider.getUser;

    return StreamBuilder(
      // Stream qui écoute la collection 'posts' dans Firestore
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Si une erreur se produit dans le snapshot
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // Si les données sont encore en train de charger
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Si les données sont chargées
        final data = snapshot.data!.docs;

        // Transformer chaque document en une instance de Post
        final posts = data.map((doc) => Post.fromSnapshot(doc)).toList();

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index]; // Accéder à l'objet Post
            //print('URL de l\'image du post : ${post.postUrl}');
            //print('URL de l\'image de profil : ${post.profImage}');

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with profile image, username, and more icon
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(post.profImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () async {
                            final postStorage =
                                PostStorage(); // Create instance of PostStorage

                            try {
                              // Delete the post
                              await postStorage.deletePost(
                                  post.postId); // Pass the postId to delete

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post Deleted'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete post: $e'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Caption of the post
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      // Utilise Center pour centrer le texte
                      child: Text(
                        post.caption,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Image of the post
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
                  // Icons for post actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row pour les icônes de gauche
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                post.likes.contains(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: post.likes.contains(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              onPressed: () {
                                toggleLike(post); // Appel de la fonction
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        // Icône pour le côté droit
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Texte affichant le nombre de likes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      '${post.likes.length} Liked',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}