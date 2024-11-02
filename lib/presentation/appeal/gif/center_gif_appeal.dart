import 'package:flutter/material.dart';

class CenterGifAppealWidget extends StatefulWidget {
  final String path;

  const CenterGifAppealWidget({Key? key, required this.path}) : super(key: key);

  @override
  _CenterGifAppealWidgetState createState() => _CenterGifAppealWidgetState();
}

class _CenterGifAppealWidgetState extends State<CenterGifAppealWidget>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false; // 初期状態では非表示

  @override
  void initState() {
    super.initState();

    // 何秒待ってから表示するかはここで調整しよう
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });

        // 何秒間表示するかはここで調整しよう
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

    return Center(
      child: Image.asset(widget.path),
    );
  }
}
