import 'package:flutter/material.dart';

class LeftBottomGifAppealWidget extends StatefulWidget {
  final String path;

  const LeftBottomGifAppealWidget({Key? key, required this.path}) : super(key: key);

  @override
  _LeftBottomGifAppealWidgetState createState() => _LeftBottomGifAppealWidgetState();
}

class _LeftBottomGifAppealWidgetState extends State<LeftBottomGifAppealWidget> {
  bool _isVisible = false; // 初期状態では非表示

  @override
  void initState() {
    super.initState();

    // 3秒待ってから表示を開始
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });

        // 5秒間表示した後に非表示にする
        Future.delayed(const Duration(seconds: 5), () {
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
      alignment: Alignment.bottomLeft, // 左下に配置
      child: Image.asset(widget.path),
    );
  }
}
