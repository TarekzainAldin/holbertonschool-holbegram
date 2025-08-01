import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  // Properties of the Post class
  String caption;
  String uid;
  String username;
  List<String> likes; // Assuming likes is a list of user IDs
  String postId;
  DateTime datePublished;
  String postUrl;
  String profImage;

  // Constructor
  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  // Create an instance from a Firestore DocumentSnapshot (fromSnapshot method)
  factory Post.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      caption: snapshot['caption'] ?? '',
      uid: snapshot['uid'] ?? '',
      username: snapshot['username'] ?? '',
      likes: List<String>.from(
          snapshot['likes'] ?? []), // Ensure it is a list of Strings
      postId: snapshot['postId'] ?? '',
      datePublished: (snapshot['datePublished'] as Timestamp).toDate(),
      postUrl: snapshot['postUrl'] ?? '',
      profImage: snapshot['profImage'] ?? '',
    );
  }

  // Convert the Post instance to a JSON-compatible map (toJson method)
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'likes': likes,
      'postId': postId,
      'datePublished': Timestamp.fromDate(datePublished),
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }
}
