import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Uploads an image to Firebase Storage.
  ///
  /// Parameters:
  /// - [path]: The folder path in Firebase Storage.
  /// - [file]: The image file data as a Uint8List.
  /// - [isPost]: A boolean indicating whether the upload is for a post.
  ///
  /// Returns the download URL of the uploaded image.
  Future<String> uploadImageToStorage(
    String path,
    Uint8List file,
    bool isPost,
  ) async {
    try {
      // Reference the storage location
      Reference ref = _storage.ref().child(path).child(_auth.currentUser!.uid);

      // If it's a post, generate a unique ID for the image
      if (isPost) {
        String id = const Uuid().v1(); // Unique ID for posts
        ref = ref.child(id);
      }

      // Upload the file to the reference
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;

      // Retrieve and return the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Log the error for debugging purposes
      print('Failed to upload image: $e');
      return ''; // Return an empty string on failure
    }
  }
}