import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tfh2024/presentation/display/diplay_pdf_view.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart'; // Clipboard機能のために追加

import '../upload/upload_pdf_view.dart';

class ShowFormUrlPage extends StatefulWidget {
  final PdfViewerArguments arguments;

  const ShowFormUrlPage({
    super.key,
    required this.arguments,
  });

  @override
  State<ShowFormUrlPage> createState() => _ShowFormUrlPageState();
}

class _ShowFormUrlPageState extends State<ShowFormUrlPage> {
  late String pdfId;
  late String url;

  @override
  void initState() {
    super.initState();
    pdfId = _generateRandomId();
    url = 'https://comment-form.web.app/add.html?id=$pdfId';
  }

  String _generateRandomId() {
    // ランダムな値でpdfIdを生成
    return const Uuid().v4();
  }

  void _startPresentation() {
    // pdfIdを引数に追加してPdfViewerScreenを呼び出し
    final updatedArguments = widget.arguments.copyWith(
      url: url,
      pdfId: pdfId,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(arguments: updatedArguments),
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URLをコピーしました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレゼンテーション設定'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 中央に配置するために追加
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'URL: $url',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // QRコードを表示
              QrImageView(
                data: url,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startPresentation,
                child: const Text('発表開始'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
