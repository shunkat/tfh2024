import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({super.key});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    if (_isFirstLoad) {
      _openPDF();
      _isFirstLoad = false;
    }
  }

  Future<void> _openPDF() async {
    try {
      // テンポラリディレクトリを取得
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/sample.pdf';
      final file = File(filePath);

      // アセットからPDFファイルを読み込む
      final bytes = await rootBundle.load('assets/sample.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      // PDFを開く
      await OpenFile.open(filePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _openPDF,
                child: const Text('PDFを開く'),
              ),
      ),
    );
  }
}
