import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/audio/audio_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/center_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/text/text_flow_appeal.dart';

class AppealController extends StatefulWidget {
  final int value;

  const AppealController({Key? key, required this.value})
      : assert(value >= 0 && value <= 10),
        super(key: key);

  @override
  State<AppealController> createState() => _AppealControllerState();
}

class _AppealControllerState extends State<AppealController> {
  final AudioAppeal _audioAppeal = AudioAppeal();

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  @override
  void didUpdateWidget(AppealController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initAudio();
    }
  }

  @override
  void dispose() {
    _audioAppeal.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    await _audioAppeal.initialize(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.value) {
      case 1:
        // 引数が1の場合、TextFlowAppealWidgetを表示
        return TextFlowAppealWidget(
          texts: ['こんにちは', 'おはよう', 'こんばんは', "草", "wwwwwwww", "草", "最高"],
        );
      case 2:
        // 引数が2の場合、CenterGifAppealWidgetを表示
        return CenterGifAppealWidget(path: 'assets/images/center_appeal.gif');
      default:
        // その他の数値の場合、適当なウィジェット（ここではTextウィジェット）を表示
        return Center(
          child: Text(
            '数値は ${widget.value} です',
            style: const TextStyle(fontSize: 24),
          ),
        );
    }
  }
}
