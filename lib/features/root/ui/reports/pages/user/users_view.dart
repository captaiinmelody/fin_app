import 'dart:io';

import 'package:fin_app/features/auth/components/auth_input_components.dart';
import 'package:flutter/material.dart';

class UserViewReportsPage extends StatefulWidget {
  final TextEditingController descriptionController, locationDetailController;

  final Widget displayMedia, buttonMedia, campusSelection;

  final File? imageFile, videoFile;
  const UserViewReportsPage({
    super.key,
    required this.descriptionController,
    required this.locationDetailController,
    required this.displayMedia,
    required this.buttonMedia,
    required this.campusSelection,
    this.imageFile,
    this.videoFile,
  });

  @override
  State<UserViewReportsPage> createState() => _UserViewReportsPageState();
}

class _UserViewReportsPageState extends State<UserViewReportsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: widget.descriptionController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter some description...',
                    ),
                  ),
                  if (widget.imageFile != null || widget.videoFile != null)
                    widget.displayMedia
                  else
                    const Text(
                      "Image or Video is required...",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  const SizedBox(height: 24),
                  widget.buttonMedia,
                  widget.campusSelection,
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: AuthForm(
                      controller: widget.locationDetailController,
                      labelText: 'Location details...',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
