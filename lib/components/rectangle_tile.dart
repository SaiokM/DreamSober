import 'package:flutter/material.dart';

class RectangleTile extends StatelessWidget {
  final String imagePath; // The path to the image asset
  final Function()? onTap;

  const RectangleTile({
    Key? key,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath, // Display the image from the provided imagePath
          height: 60,
          width: 240,
          fit: BoxFit.cover, // Adjust the image to cover the container
        ),
      ),
    );
  }
}
