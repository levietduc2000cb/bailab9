import 'package:flutter/material.dart';

import '../models/user.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Image.network(
            user.image,
            height: 150,
            width: 150,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          user.firstName,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          'ID: ${user.id}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
