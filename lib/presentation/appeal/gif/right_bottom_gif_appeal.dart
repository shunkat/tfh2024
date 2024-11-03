import 'package:flutter/material.dart';

class RightBottomGifAppealWidget extends StatefulWidget {
  final String path;
  final Duration initialDelay;
  final Duration displayDuration;

  const RightBottomGifAppealWidget({
    Key? key,
    required this.path,
    required this.initialDelay,
    required this.displayDuration,
  }) : super(key: key);

  @override
  _RightBottomGifAppealWidgetState createState() =>
      _RightBottomGifAppealWidgetState();
}

class _RightBottomGifAppealWidgetState
    extends State<RightBottomGifAppealWidget> {
  bool _isVisible = false; // 初期状態では非表示

  @override
  void initState() {
    super.initState();

    // 始まるまでのdelayを受け取ってから表示を開始
    Future.delayed(widget.initialDelay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });

        // 表示時間を受け取ってから非表示にする
        Future.delayed(widget.displayDuration, () {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      // GIFが表示されていない場合は何も表示しない
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.bottomRight, // 右下に配置
      child: Image.asset(widget.path),
    );
  }
}
