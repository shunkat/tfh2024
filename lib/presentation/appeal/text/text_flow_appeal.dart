import 'package:flutter/material.dart';
import 'dart:math';

class TextFlowAppealWidget extends StatefulWidget {
  final List<String> texts;

  const TextFlowAppealWidget({Key? key, required this.texts}) : super(key: key);

  @override
  _TextFlowAppealWidgetState createState() => _TextFlowAppealWidgetState();
}

class _TextFlowAppealWidgetState extends State<TextFlowAppealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double screenWidth = 0;
  double textWidth = 0;
  double screenHeight = 0;
  double _topPosition = 0;

  int _currentIndex = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // アニメーションコントローラーの初期化
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // アニメーションのステータスリスナーを追加
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 左に流れ終わった後、2秒待ってから再開
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            // 次の文字列に切り替え
            _currentIndex = (_currentIndex + 1) % widget.texts.length;
            // ランダムな高さを設定
            _topPosition = _getRandomTopPosition();
            // テキストの幅を再計算
            _measureTextWidth();
            // アニメーションの範囲を再設定
            _animation = Tween<double>(
              begin: screenWidth,
              end: -textWidth,
            ).animate(_controller);
            // アニメーションを再開
            _controller.reset();
            _controller.forward();
          });
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 画面の幅と高さを取得
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    // 初期のテキストの幅を計算
    _measureTextWidth();

    // 初期の高さをランダムに設定
    _topPosition = _getRandomTopPosition();

    // アニメーションの初期設定
    _animation = Tween<double>(
      begin: screenWidth,
      end: -textWidth,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // アニメーションを開始
    _controller.forward();
  }

  void _measureTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.texts[_currentIndex],
        style: const TextStyle(fontSize: 32.0), // 大きな文字サイズ
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    textWidth = textPainter.size.width;
  }

  double _getRandomTopPosition() {
    // 画面の上部から下部までのランダムな位置を返す
    return _random.nextDouble() * (screenHeight - 50); // 50はテキストの高さを考慮
  }

  @override
  void dispose() {
    // コントローラーの破棄
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight,
      child: Stack(
        children: [
          Positioned(
            left: _animation.value,
            top: _topPosition,
            child: Text(
              widget.texts[_currentIndex],
              style: const TextStyle(
                fontSize: 32.0, // 大きな文字サイズ
                color: Colors.red, // 赤色
              ),
            ),
          ),
        ],
      ),
    );
  }
}
