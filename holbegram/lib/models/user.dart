import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  // Properties of the Users class
  String uid;
  String email;
  String username;
  String bio;
  String photoUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  List<dynamic> saved;
  String searchKey;

  // Constructor
  Users({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  // Create an instance from a Firestore DocumentSnapshot
  factory Users.fromSnap(DocumentSnapshot snap) {
    // Fetch the data from the DocumentSnapshot
    var snapshot = snap.data() as Map<String, dynamic>;

    // Return a new Users instance with the data from the snapshot
    return Users(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      username: snapshot['username'] ?? '',
      bio: snapshot['bio'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      followers: snapshot['followers'] ?? [],
      following: snapshot['following'] ?? [],
      posts: snapshot['posts'] ?? [],
      saved: snapshot['saved'] ?? [],
      searchKey: snapshot['searchKey'] ?? '',
    );
  }

  // Convert the Users instance to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'saved': saved,
      'searchKey': searchKey,
    };
  }
}
