import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/text/components/animated_text_item.dart';

class TextFlowAppealWidget extends StatelessWidget {
  final List<String> texts;
  final int minDelay; // 最小遅延時間
  final int maxDelay; // 最大遅延時間
  List<String>? firebaseTexts;
  final Future<void> Function(String)? onAnimationComplete;
  final List<String>? commentIds;

  TextFlowAppealWidget({
    super.key,
    required this.texts,
    this.firebaseTexts,
    this.minDelay = 0, // デフォルト値を1秒に設定
    this.maxDelay = 0,
    this.onAnimationComplete,
    this.commentIds, // デフォルト値を5秒に設定
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Stack(
      children: texts.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        final commentId = commentIds?[index];

        // minDelayからmaxDelayの範囲でランダムな数字を生成
        //指定しない場合は0(主にfirestoreからのテキストを想定)
        final delay = (minDelay != 0 || maxDelay != 0)
            ? random.nextInt(maxDelay - minDelay + 1) + minDelay
            : 0;

        return AnimatedTextItem(
          text: text,
          delayInSeconds: delay,
          onAnimationComplete: onAnimationComplete != null
              ? () => onAnimationComplete!(commentId!)
              : null,
        );
      }).toList(),
    );
  }
}
