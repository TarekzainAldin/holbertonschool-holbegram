import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../methods/auth_methods.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../screens/home.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image; // Variable to store the image in memory
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
  final AuthMethods _authMethods = AuthMethods(); // Instance of AuthMethods

  /// Method to pick an image from the gallery
  Future<void> selectImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        // Convert the selected image to Uint8List
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (e) {
      // Handle any errors that occur during the image selection
      print('Error selecting image from gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  /// Method to capture an image from the camera
  Future<void> selectImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        // Convert the captured image to Uint8List
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (e) {
      // Handle any errors that occur during the image capture
      print('Error capturing image from camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $e')),
      );
    }
  }

  /// Method to handle sign-up process
  Future<void> handleSignUp() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Extracting data from widget
    final String email = widget.email;
    final String password = widget.password;
    final String username = widget.username;

    // Calling the signUpUser method from AuthMethods
    String result = await _authMethods.signUpUser(
      email: email,
      password: password,
      username: username,
      file: _image!,
    );

    if (result == 'success') {
      // Show a snackbar on success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up successful!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      // Show an error message if sign-up fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  /// Request camera and storage permissions
  Future<void> requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var storageStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !storageStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Camera and gallery permissions are required.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Request permissions when the screen initializes
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Image(
              width: 80,
              height: 60,
              image: AssetImage('assets/images/logo.webp'),
            ),
            const SizedBox(height: 20),

            // Welcome message
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hello, ${widget.username} Welcome to Holbegram.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const Text(
              'Choose an image from your gallery or take a new one.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Display the selected or captured image if it exists, otherwise show the default image
            _image != null
                ? ClipOval(
                    child: Image.memory(
                      _image!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipOval(
                    child: Image.asset(
                      'assets/images/Sample_User_Icon.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(height: 20),

            // Row to place IconButtons side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button to select an image from the gallery
                IconButton(
                  onPressed: selectImageFromGallery,
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Colors.red,
                  ),
                ),

                // Button to capture an image using the camera
                IconButton(
                  onPressed: selectImageFromCamera,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Button to proceed with sign-up
            ElevatedButton(
              onPressed: handleSignUp,
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.red),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
