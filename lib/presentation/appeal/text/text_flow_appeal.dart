import 'dart:math'; // Randomクラスを使用するために追加
import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/text/components/animated_text_item.dart';

class TextFlowAppealWidget extends StatelessWidget {
  final List<String> texts;
  List<String>? firebaseTexts;

  TextFlowAppealWidget({
    super.key,
    required this.texts,
    this.firebaseTexts,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(); // Randomインスタンスを作成

    return Stack(
      children: texts.asMap().entries.map((entry) {
        final text = entry.value;
        final delay = random.nextInt(5) + 1; // 1から5のランダムな数字を生成

        return AnimatedTextItem(
          text: text,
          delayInSeconds: delay, // ランダムな遅延時間を渡す
        );
      }).toList(),
    );
  }
}
