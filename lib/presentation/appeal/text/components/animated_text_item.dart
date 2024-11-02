import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedTextItem extends StatefulWidget {
  final String text;
  final int delayInSeconds; // 遅延時間を追加

  const AnimatedTextItem({
    Key? key,
    required this.text,
    required this.delayInSeconds, // 引数に遅延時間を追加
  }) : super(key: key);

  @override
  _AnimatedTextItemState createState() => _AnimatedTextItemState();
}

class _AnimatedTextItemState extends State<AnimatedTextItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  double screenWidth = 0;
  double screenHeight = 0;
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

    // テキストの幅を計算し、アニメーションを初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimation();
    });
  }

  void _initializeAnimation() {
    _measureTextWidth();

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

    // アニメーションの初期設定（開始位置をテキストの初期位置に合わせる）
    _animation = Tween<double>(
      begin: screenWidth - textWidth,
      end: -textWidth,
    ).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    // 指定された遅延後にアニメーションを開始
    Future.delayed(
      Duration(seconds: widget.delayInSeconds),
      () {
        if (mounted) {
          _controller?.forward();
        }
      },
    );
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
    // 画面サイズが未取得の場合は取得
    if (screenWidth == 0 || screenHeight == 0) {
      final size = MediaQuery.of(context).size;
      screenWidth = size.width;
      screenHeight = size.height;
      _topPosition = _getRandomTopPosition();
    }

    double leftPosition;

    if (_controller == null || _animation == null || _controller!.isDismissed) {
      // アニメーションがまだ開始されていない場合
      leftPosition = screenWidth - textWidth; // テキストを右端に配置
    } else {
      leftPosition = _animation!.value;
    }

    return Positioned(
      left: leftPosition,
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
