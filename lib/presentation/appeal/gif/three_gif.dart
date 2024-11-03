import 'package:flutter/material.dart';

class ThreeGifWidget extends StatefulWidget {
  final String path1;
  final String path2;
  final String path3;

  const ThreeGifWidget({
    Key? key,
    required this.path1,
    required this.path2,
    required this.path3,
  }) : super(key: key);

  @override
  _ThreeGifWidgetState createState() => _ThreeGifWidgetState();
}

class _ThreeGifWidgetState extends State<ThreeGifWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Alignment> _animation1;

  late AnimationController _controller2;
  late Animation<Alignment> _animation2;

  @override
  void initState() {
    super.initState();

    // 下すぎるので、Y座標を少し上げる（-1.0が上、1.0が下）
    // Y座標を0.8に設定して、下から少し上に配置
    _controller1 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation1 = AlignmentTween(
      begin: Alignment(1.0, 0.8),  // 右下から少し上
      end: Alignment(-1.0, 0.8),   // 左下から少し上
    ).animate(_controller1);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation2 = AlignmentTween(
      begin: Alignment(-1.0, 0.8), // 左下から少し上
      end: Alignment(1.0, 0.8),    // 右下から少し上
    ).animate(_controller2);

    // アニメーションを開始
    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 最初のGIF：右下から左下へ移動
        AlignTransition(
          alignment: _animation1,
          child: Image.asset(widget.path1),
        ),
        // 二番目のGIF：左下から右下へ移動
        AlignTransition(
          alignment: _animation2,
          child: Image.asset(widget.path2),
        ),
        // 三番目のGIF：左上に固定表示
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(widget.path3),
        ),
      ],
    );
  }
}
