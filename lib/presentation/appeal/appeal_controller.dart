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
        mainWidget = TextFlowAppealWidget(
          texts: ['こんにちは', 'おはよう', 'こんばんは', "草", "wwwwwwww", "草", "最高"],
          minDelay: 0,
          maxDelay: 5,
        );
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

    return Stack(
      children: [
        mainWidget,
        // Add the StreamBuilder on top of the mainWidget
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
      ],
    );
  }
}
