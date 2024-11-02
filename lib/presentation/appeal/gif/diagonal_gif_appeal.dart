import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math';

class DiagonalGifAppealWidget extends StatefulWidget {
  final String path;

  const DiagonalGifAppealWidget({Key? key, required this.path}) : super(key: key);

  @override
  _DiagonalGifAppealWidgetState createState() => _DiagonalGifAppealWidgetState();
}

class _DiagonalGifAppealWidgetState extends State<DiagonalGifAppealWidget> {
  ui.Image? _image;
  bool _isLoading = true;
  bool _showGif = false; // GIFを表示するかどうかのフラグ

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  /// GIF画像をロードし、オリジナルの寸法を取得します。
  Future<void> _loadImage() async {
    final ImageStream stream =
        AssetImage(widget.path).resolve(const ImageConfiguration());
    final Completer<ui.Image> completer = Completer<ui.Image>();
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);

    final ui.Image image = await completer.future;
    setState(() {
      _image = image;
      _isLoading = false;
    });

    // 画像がロードされた後、4秒待ってからGIFを表示
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _showGif = true;
      });

      // 5秒後にGIFを非表示にする
      Timer(const Duration(seconds: 5), () {
        setState(() {
          _showGif = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _image == null) {
      // 画像がロードされるまでローディングインジケーターを表示
      return const Center(child: CircularProgressIndicator());
    }

    if (!_showGif) {
      // GIFを表示しない場合は空のコンテナを返す
      return Container();
    }

    // GIF画像のオリジナルの寸法
    final imageWidth = _image!.width.toDouble();
    final imageHeight = _image!.height.toDouble();

    // 画面の寸法
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<Widget> imageWidgets = [];

    // 左端と下端に到達するために必要な画像の数を計算
    int nHorizontal = (screenWidth / imageWidth).ceil();
    int nVertical = (screenHeight / imageHeight).ceil();
    int n = max(nHorizontal, nVertical);

    // 水平方向と垂直方向の間隔を計算
    double hSpacing = (screenWidth - imageWidth) / (n - 1);
    double vSpacing = (screenHeight - imageHeight) / (n - 1);

    for (int i = 0; i < n; i++) {
      double leftPosition = screenWidth - imageWidth - i * hSpacing;
      double topPosition = i * vSpacing;

      // 画像が画面外に完全に出たらループを抜ける
      if (leftPosition + imageWidth < 0 || topPosition > screenHeight) {
        break;
      }

      // 現在の画像のPositionedウィジェットを追加
      imageWidgets.add(Positioned(
        left: leftPosition,
        top: topPosition,
        child: Image.asset(
          widget.path,
        ),
      ));
    }

    return Stack(
      children: imageWidgets,
    );
  }
}
