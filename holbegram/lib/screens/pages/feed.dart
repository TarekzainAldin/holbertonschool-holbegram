// feed.dart
import 'package:flutter/material.dart';
import '../../utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AppBar title with Holbegram and logo
              Row(
                children: [
                  const Text(
                    'Holbegram',
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logo.webp',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              // Icons on the right side
              const Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.message_outlined,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: const Posts());
  }
}