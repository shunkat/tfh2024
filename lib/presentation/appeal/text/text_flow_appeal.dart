import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/text/components/animated_text_item.dart';

class TextFlowAppealWidget extends StatelessWidget {
  final List<String> texts;

  const TextFlowAppealWidget({super.key, required this.texts});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: texts.map((text) {
        return AnimatedTextItem(
          text: text,
        );
      }).toList(),
    );
  }
}
