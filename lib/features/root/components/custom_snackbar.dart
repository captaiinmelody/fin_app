import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const CustomSnackBar({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Customize the background color as needed
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white, // Customize the icon color as needed
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white, // Customize the title color as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                body,
                style: TextStyle(
                  color: Colors.white, // Customize the body color as needed
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
