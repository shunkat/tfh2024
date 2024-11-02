import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/audio/audio_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/center_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/diagonal_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/left_bottom_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/text/text_flow_appeal.dart';

import '../../data/comment/commentModel.dart';
import '../../data/comment/commentRepository.dart';

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
        return CenterGifAppealWidget(path: 'assets/gif/happy-cat.gif');
      case 3:
        // 引数が3の場合、AudioAppealを表示
        return DiagonalGifAppealWidget(path: 'assets/gif/happy-cat.gif');
      case 4:
        // 引数が4の場合、AudioAppealを表示
        return LeftBottomGifAppealWidget(path: 'assets/gif/happy-cat.gif');
      default:
        // その他の数値の場合、適当なウィジェット（ここではTextウィジェット）を表示
        return Center(
          child: Column(
            children: [
              Text(
                '数値は ${widget.value} です',
                style: const TextStyle(fontSize: 24),
              ),
              Expanded(
                child: SimpleCommentTest(appealValue: widget.value),
              ),
            ],
          ),
        );
    }
  }
}

class SimpleCommentTest extends StatelessWidget {
  final int appealValue;
  final CommentsRepository _repository = CommentsRepository();

  SimpleCommentTest({
    super.key,
    required this.appealValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<Comment>>(
        // appealValueを文字列に変換してpdfIdとして使用
        stream: _repository.getCommentsForPdf('testpdfId'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final comments = snapshot.data ?? [];

          final commentsText =
              comments.map((comment) => comment.content).join('\n');

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                commentsText.isEmpty ? 'コメントなし' : commentsText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _repository.addComment(
                    'testpdfId',
                    'テストコメント${DateTime.now()}',
                  );
                },
                child: Text('テストコメント追加'),
              ),
            ],
          );
        },
      ),
    );
  }
}
