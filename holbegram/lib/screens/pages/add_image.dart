import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './methods/post_storage.dart';
import '../../methods/auth_methods.dart';
import '../../models/user.dart';

class AddImage extends StatefulWidget {
  final PageController pageController;
  const AddImage({required this.pageController, super.key});

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _image;
  String caption = '';
  final TextEditingController _captionController = TextEditingController();

  // Méthode pour sélectionner une image dans la galerie
  Future<void> selectImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  // Méthode pour capturer une image avec la caméra
  Future<void> selectImageFromCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $e')),
      );
    }
  }

  // Affiche les options pour choisir la source de l'image (galerie ou caméra)
  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      selectImageFromGallery(context);
                    },
                    icon: const Icon(Icons.photo_library, size: 40),
                  ),
                  const Text('Gallery'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      selectImageFromCamera(context);
                    },
                    icon: const Icon(Icons.camera_alt, size: 40),
                  ),
                  const Text('Camera'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Fonction pour appeler la méthode uploadPost lors du clic sur "Post"
  void _postImage() async {
    if (_image == null || caption.isEmpty) {
      // Si aucune image n'est sélectionnée ou si la légende est vide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an image and enter a caption')),
      );
      return;
    }

    // Récupération des données de l'utilisateur connecté
    final user = FirebaseAuth.instance.currentUser;
    final AuthMethods authMethods = AuthMethods();

    if (user != null) {
      // Récupérer les informations personnalisées de Firestore
      Users? userDetails = await authMethods.getUserDetails();

      if (userDetails != null) {
        String uid = userDetails.uid;
        String username = userDetails.username;
        String profImage = userDetails.photoUrl;

        // Appel de la méthode uploadPost
        String result = await PostStorage()
            .uploadPost(caption, uid, username, profImage, _image!);

        if (result == 'Ok') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post uploaded successfully!')),
          );
          // Réinitialisation après la publication du post
          setState(() {
            _image = null;
            caption = '';
            _captionController.clear();
          });
          // Redirection vers l'onglet Home
          widget.pageController.jumpToPage(0);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading post: $result')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Image',
              style: TextStyle(
                fontFamily: 'InstagramSans',
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _postImage,
            child: const Text(
              'Post',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Ajouter cette ligne
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Add Image',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Choose an image from your gallery or take one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Ajouter ici un champ de texte pour la saisie de la légende
              TextField(
                controller: _captionController,
                onChanged: (value) {
                  setState(() {
                    caption = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  hintStyle: TextStyle(
                    fontSize: 20, // Augmenter la taille du texte
                    color: Colors.grey, // Changer la couleur du texte en gris
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showImageSourceOptions(context);
                },
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image == null
                        ? Center(
                            child: Image.asset(
                              'assets/images/add-2935429_960_720.webp',
                              fit: BoxFit.contain,
                              height: 100,
                              width: 100,
                            ),
                          )
                        : ClipRRect(
                            child: Image.memory(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
