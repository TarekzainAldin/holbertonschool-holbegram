import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchQuery = '';
  List filteredPosts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;
          final posts = data.map((doc) => doc.data()).toList();

          // Filtrage des posts basés sur la recherche dans le caption
          filteredPosts = posts.where((post) {
            final data = post as Map<String, dynamic>; // Cast en Map
            return data['caption']
                .toString()
                .toLowerCase()
                .contains(searchQuery);
          }).toList();

          if (filteredPosts.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          // Utilisation de GridView.custom avec SliverQuiltedGridDelegate
          return GridView.custom(
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [
                const QuiltedGridTile(2, 2),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                final post = filteredPosts[index];
                return GestureDetector(
                  onTap: () {
                    // Action sur le clic d'une image
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(post['postUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredPosts.length,
            ),
          );
        },
      ),
    );
  }
}