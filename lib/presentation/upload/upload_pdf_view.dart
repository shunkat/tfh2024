import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tfh2024/presentation/form/show_form_url_page.dart';
import 'dart:typed_data' show Uint8List;

class PdfViewerArguments {
  final Uint8List pdfData;
  final String? fileName;
  final String pdfId;

  PdfViewerArguments(
      {required this.pdfData, this.fileName, required this.pdfId});

  copyWith({required String pdfId, required String url}) {
    return PdfViewerArguments(
      pdfData: pdfData,
      fileName: fileName,
      pdfId: pdfId,
    );
  }
}

class UploadPdfView extends StatefulWidget {
  const UploadPdfView({super.key});

  @override
  State<UploadPdfView> createState() => _UploadPdfViewState();
}

class _UploadPdfViewState extends State<UploadPdfView> {
  bool _isLoading = false;

  Future<void> _pickPDF() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final bytes = result.files.first.bytes;
        final fileName = result.files.first.name;

        if (bytes != null && mounted) {
          final pdfData = Uint8List.fromList(bytes);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShowFormUrlPage(
                arguments: PdfViewerArguments(
                  pdfData: pdfData,
                  fileName: fileName,
                  pdfId: '',
                ),
              ),
            ),
          );
          return;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ファイルが選択されませんでした')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDFの読み込みエラー: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // デバイスのサイズを取得
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // 白い四角形のサイズを比率で設定
    final boxWidth = screenWidth * 0.85; // 幅の85%
    final boxHeight = screenHeight * 0.75; // 高さの75%

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 背景のグラデーション
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.2),
                  Colors.redAccent.withOpacity(0.9),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          // 中央の白い四角形を配置
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: boxWidth, // 幅を比率で設定
              height: boxHeight, // 高さを比率で設定
              decoration: BoxDecoration(
                color: Colors.white, // 背景色を白に設定
                borderRadius: BorderRadius.circular(15), // 角を丸くする
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(15, 15), // 影の位置
                  ),
                ],
              ),
              child: SingleChildScrollView(
                // スクロール可能にする
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/title.png',
                      fit: BoxFit.cover,
                      width: boxWidth * 0.9, // 幅を比率で設定
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _pickPDF,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        backgroundColor: Colors.white, // 背景色を白に設定
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // 角を丸くする
                          side: const BorderSide(
                              color: Colors.black, width: 2), // 黒い縁
                        ),
                      ),
                      child: Text(
                        _isLoading ? 'Loading...' : 'Upload PDF',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black, // テキストの色を黒に設定
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 背景GIFを四角形の上に配置
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/dance.gif',
            ),
          ),
        ],
      ),
    );
  }
}
