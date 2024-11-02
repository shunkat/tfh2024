import 'package:flutter/material.dart';
import 'dart:math';

class TextFlowAppealWidget extends StatefulWidget {
  final List<String> texts;

  const TextFlowAppealWidget({Key? key, required this.texts}) : super(key: key);

  @override
  _TextFlowAppealWidgetState createState() => _TextFlowAppealWidgetState();
}

class _TextFlowAppealWidgetState extends State<TextFlowAppealWidget> {
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.texts.map((text) {
        return _AnimatedTextItem(
          text: text,
          delay: Duration(
            seconds: _random.nextInt(5) + 5, // 5~10秒間のランダムな遅延
          ),
        );
      }).toList(),
    );
  }
}

class _AnimatedTextItem extends StatefulWidget {
  final String text;
  final Duration delay;

  const _AnimatedTextItem({Key? key, required this.text, required this.delay})
      : super(key: key);

  @override
  __AnimatedTextItemState createState() => __AnimatedTextItemState();
}

class __AnimatedTextItemState extends State<_AnimatedTextItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  late double screenWidth;
  late double screenHeight;
  double textWidth = 0;
  double _topPosition = 0;

  final Random _random = Random();

  late Color _backgroundColor;

  final List<Color> _backgroundColors = [
    Color(0xFFFFEC6F),
    Color(0xFFFF7F7F),
    Color(0xFFD798FF),
    Color(0xFFFFA73C),
  ];

  @override
  void initState() {
    super.initState();

    // 背景色をランダムに選択
    _backgroundColor =
        _backgroundColors[_random.nextInt(_backgroundColors.length)];

    // テキストの幅を計算
    _measureTextWidth();

    // 遅延後にアニメーションを開始
    Future.delayed(widget.delay, () {
      if (!mounted) return;

      // 画面の幅と高さを取得
      final size = MediaQuery.of(context).size;
      screenWidth = size.width;
      screenHeight = size.height;

      // ランダムな高さを設定
      _topPosition = _getRandomTopPosition();

      // アニメーションコントローラーの初期化（5秒間で流れる）
      _controller = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this,
      );

      // アニメーションの初期設定
      _animation = Tween<double>(
        begin: screenWidth,
        end: -textWidth,
      ).animate(_controller!)
        ..addListener(() {
          setState(() {});
        });

      // アニメーションを開始
      _controller!.forward();
    });
  }

  void _measureTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: const TextStyle(fontSize: 32.0),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    textWidth = textPainter.size.width;
  }

  double _getRandomTopPosition() {
    return _random.nextDouble() * (screenHeight - 50); // テキストの高さを考慮
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || (!_controller!.isAnimating && !_controller!.isCompleted)) {
      // アニメーションがまだ開始されていない場合や、完了した場合は何も表示しない
      return SizedBox.shrink();
    }

    return Positioned(
      left: _animation?.value ?? screenWidth,
      top: _topPosition,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 32.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
