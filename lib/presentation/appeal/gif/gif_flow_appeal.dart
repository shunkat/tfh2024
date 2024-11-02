import 'package:flutter/material.dart';

class GifFlowAppealWidget extends StatefulWidget {
  final String path;

  const GifFlowAppealWidget({Key? key, required this.path}) : super(key: key);

  @override
  _GifFlowAppealWidgetState createState() => _GifFlowAppealWidgetState();
}

class _GifFlowAppealWidgetState extends State<GifFlowAppealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a 5-second duration
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Define the alignment animation from bottom-left to bottom-right
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.bottomLeft,
      end: Alignment.bottomRight,
    ).animate(_controller);

    // Start the animation after a 3-second delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
        _controller.forward();
      }
    });

    // Hide the image when the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      // If the GIF is not visible, display nothing
      return const SizedBox.shrink();
    }

    return AlignTransition(
      alignment: _alignmentAnimation,
      child: Image.asset(widget.path),
    );
  }
}
