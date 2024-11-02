import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math';

class DiagonalGifAppealWidget extends StatefulWidget {
  final String path;

  const DiagonalGifAppealWidget({Key? key, required this.path}) : super(key: key);

  @override
  _DiagonalGifAppealWidgetState createState() => _DiagonalGifAppealWidgetState();
}

class _DiagonalGifAppealWidgetState extends State<DiagonalGifAppealWidget> {
  ui.Image? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  /// Loads the GIF image and retrieves its original dimensions.
  Future<void> _loadImage() async {
    final ImageStream stream =
        AssetImage(widget.path).resolve(const ImageConfiguration());
    final Completer<ui.Image> completer = Completer<ui.Image>();
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);

    final ui.Image image = await completer.future;
    setState(() {
      _image = image;
      _isLoading = false;
    });
  }

  @override
Widget build(BuildContext context) {
  if (_isLoading || _image == null) {
    // Display a loading indicator while the image is being loaded.
    return const Center(child: CircularProgressIndicator());
  }

  // Original dimensions of the GIF image.
  final imageWidth = _image!.width.toDouble();
  final imageHeight = _image!.height.toDouble();

  // Dimensions of the screen.
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  List<Widget> imageWidgets = [];

  // Calculate the number of images needed to reach both left and bottom edges.
  int nHorizontal = (screenWidth / imageWidth).ceil();
  int nVertical = (screenHeight / imageHeight).ceil();
  int n = max(nHorizontal, nVertical);

  // Calculate horizontal and vertical spacing.
  double hSpacing = (screenWidth - imageWidth) / (n - 1);
  double vSpacing = (screenHeight - imageHeight) / (n - 1);

  for (int i = 0; i < n; i++) {
    double leftPosition = screenWidth - imageWidth - i * hSpacing;
    double topPosition = i * vSpacing;

    // Break the loop if the image is completely out of the screen bounds.
    if (leftPosition + imageWidth < 0 || topPosition > screenHeight) {
      break;
    }

    // Add the Positioned widget for the current image.
    imageWidgets.add(Positioned(
      left: leftPosition,
      top: topPosition,
      child: Image.asset(
        widget.path,
      ),
    ));
  }

  return Stack(
    children: imageWidgets,
  );
}
}