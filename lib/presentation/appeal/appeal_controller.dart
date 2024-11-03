import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/appeal/audio/audio_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/diagonal_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/three_gif.dart';
import 'package:tfh2024/presentation/appeal/gif/gif_flow_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/left_bottom_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/gif/right_bottom_gif_appeal.dart';
import 'package:tfh2024/presentation/appeal/text/text_flow_appeal.dart';

import '../../data/comment/commentModel.dart';
import '../../data/comment/commentRepository.dart';

class AppealController extends StatefulWidget {
  final int value;
  final String pdfId;

  const AppealController({super.key, required this.value, required this.pdfId})
      : assert(value >= 0 && value <= 10);

  @override
  State<AppealController> createState() => _AppealControllerState();
}

class _AppealControllerState extends State<AppealController> {
  final AudioAppeal _audioAppeal = AudioAppeal();
  final CommentsRepository _repository = CommentsRepository();

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
    Widget mainWidget;

    switch (widget.value) {
      case 0:
        mainWidget = SizedBox.shrink(); // Do not display TextFlowAppealWidget
        break;
      case 1:
        mainWidget = RightBottomGifAppealWidget(
          path: 'assets/gif/kyokan.gif',
          initialDelay: const Duration(seconds: 10),
          displayDuration: const Duration(seconds: 100),
        );
        break;
      case 2:
        mainWidget = LeftBottomGifAppealWidget(
          path: 'assets/gif/awsome.gif',
          initialDelay: const Duration(seconds: 8),
          displayDuration: const Duration(seconds: 100),
        );
        break;
      case 3:
        mainWidget = ThreeGifWidget(
          path1: 'assets/gif/dance.gif',
          path2: 'assets/gif/dance_women.gif',
          path3: 'assets/gif/oji.gif',
        );
        break;
      case 4:
        mainWidget = DiagonalGifAppealWidget(
          path: 'assets/gif/happy-cat.gif',
        );
        break;
      case 6:
        mainWidget = LeftBottomGifAppealWidget(
          path: 'assets/gif/thatshot.gif',
          initialDelay: const Duration(seconds: 1),
          displayDuration: const Duration(seconds: 100),
        );
        break;
      default:
        mainWidget = SizedBox.shrink(); // Empty widget for default case
    }

    List<Widget> stackChildren = [mainWidget];

    // Add TextFlowAppealWidget based on the value
    if (widget.value == 3) {
      stackChildren.add(
        TextFlowAppealWidget(
          texts: [
            '気になる', '面白そう', 'なんだろ', '草', 'ええやん', '期待', '楽しみ', '興味深い', 'これは', '見たい',
            '気になる', '何だ', 'わくわく', '面白そう', 'やばい', 'すごい', 'おもしろい', 'いいね', 'いい感じ', '最高'
          ],
          minDelay: 0,
          maxDelay: 5,
        ),
      );
    } else if (widget.value == 4) {
      stackChildren.add(
        TextFlowAppealWidget(
          texts: [
            '感動した', 'hotだねぇ〜', 'ええやん', '泣ける', '素晴らしい', '心に響く',
            '最高', '胸熱', '感激', '鳥肌', '感謝', 'すごい'
          ],
          minDelay: 0,
          maxDelay: 5,
        ),
      );
    } else if (widget.value == 6) {
      stackChildren.add(
        TextFlowAppealWidget(
          texts: [
            'やられた！', 'まじかよ', 'そういうことだったのか', '驚いた', 'ビックリ',
            '嘘でしょ', '本当か', '衝撃', 'びっくりした', 'すごい',
            '信じられない', '驚愕', 'やばい', '何それ', '意外',
            'マジで', 'まさか', 'えっ', 'すげー', 'すごすぎる'
          ],
          minDelay: 0,
          maxDelay: 5,
        ),
      );
    } else if (widget.value == 8) {
      stackChildren.add(
        TextFlowAppealWidget(
          texts: [
            'すごい！', '感動した！', '泣いた', '最高すぎる', '鳥肌立った',
            '涙が止まらない', '感激した', '心打たれた', '感動をありがとう', '人生変わった'
          ],
          minDelay: 0,
          maxDelay: 5,
        ),
      );
    } else if (widget.value == 10) {
      stackChildren.add(
        TextFlowAppealWidget(
          texts: [
            '乙', '88888888', 'おつかれ', 'おつ！', 'お疲れ様', '888888', 'GJ', 'おつです', '乙乙', 'おつー',
            'おつかれさま', '8888', 'おつかれ〜', '乙！', 'おつでした', '88888888', '8888', '888', 'おつ！',
            'お疲れ様でした', '8888888888', 'お疲れ様です', '乙カレー', '888888888', '乙乙乙', '乙でした', 'おつおつ',
            '乙！', '888888', '88888888', 'おつー', '乙乙', '8888', '888', 'おつです', 'お疲れ', '888888',
            '88888', '8888888', 'おつかれー', '乙カレー', '88888', '888888', '888888888', 'おつかれ', 'おつ！',
            '88888888', 'おつかれさま', '8888888888'
          ],
          minDelay: 0,
          maxDelay: 5,
        ),
      );
    }

    // Always add the StreamBuilder on top of the mainWidget
    stackChildren.add(
      StreamBuilder<List<Comment>>(
        stream: _repository.getCommentsForPdf(widget.pdfId),
        builder: (context, snapshot) {
          final comments = snapshot.data ?? [];
          final firebaseTexts =
              comments.map((comment) => comment.content).toList();
          final commentIds = comments.map((comment) => comment.id).toList();
          return TextFlowAppealWidget(
            texts: firebaseTexts,
            commentIds: commentIds,
            onAnimationComplete: (commentId) =>
                _repository.deleteComment(widget.pdfId, commentId),
          );
        },
      ),
    );

    return Stack(
      children: stackChildren,
    );
  }
}
