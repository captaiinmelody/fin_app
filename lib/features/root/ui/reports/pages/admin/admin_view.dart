import 'dart:io';

import 'package:fin_app/features/auth/components/auth_input_components.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewReportsPage extends StatefulWidget {
  final RootBloc rootBloc;
  final TextEditingController descriptionController, locationDetailController;

  final Widget displayMedia, buttonMedia, campusSelection;

  final String reportsId;

  final File? imageFile, videoFile;
  const AdminViewReportsPage({
    super.key,
    required this.rootBloc,
    required this.descriptionController,
    required this.locationDetailController,
    required this.displayMedia,
    required this.buttonMedia,
    required this.campusSelection,
    required this.reportsId,
    this.imageFile,
    this.videoFile,
  });

  @override
  State<AdminViewReportsPage> createState() => _AdminViewReportsPageState();
}

class _AdminViewReportsPageState extends State<AdminViewReportsPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    widget.rootBloc.add(AdminFixingReportsEventGet(widget.reportsId));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
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
      },
    );
  }
}
