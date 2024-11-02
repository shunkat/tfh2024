import 'package:flutter/material.dart';

class DiagonalGifAppealWidget extends StatelessWidget {
  final String path;

  const DiagonalGifAppealWidget({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    Size size = MediaQuery.of(context).size;
    double imageSize = 50.0;

    // Calculate the maximum number of images that can fit diagonally
    int maxImagesWidth = ((size.width - imageSize) / imageSize).floor();
    int maxImagesHeight = ((size.height - imageSize) / imageSize).floor();
    int numberOfImages = maxImagesWidth < maxImagesHeight ? maxImagesWidth : maxImagesHeight;

    return Stack(
      children: List.generate(numberOfImages, (i) {
        double leftPosition = size.width - imageSize - i * imageSize;
        double topPosition = i * imageSize;

        return Positioned(
          left: leftPosition,
          top: topPosition,
          child: Image.asset(
            path,
            width: imageSize,
            height: imageSize,
          ),
        );
      }),
    );
  }
}
