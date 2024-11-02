import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/text/moving_text.dart';
// MovingTextWidgetクラスを使用するために、適切な場所からインポートしてください。
// import 'path_to_moving_text_widget.dart';

class AppealController extends StatelessWidget {
  final int value;

  const AppealController({Key? key, required this.value})
      : assert(value >= 0 && value <= 10),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      // 引数が0の場合、MovingTextWidgetを表示
      return MovingTextWidget(texts: ['こんにちは', 'おはよう', 'こんばんは'],
      );
    } else {
      // その他の数値の場合、適当なウィジェット（ここではTextウィジェット）を表示
      return Center(
        child: Text(
          '数値は $value です',
          style: const TextStyle(fontSize: 24),
        ),
      );
    }
  }
}
