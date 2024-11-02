import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PdfUploadPage extends StatefulWidget {
  const PdfUploadPage({super.key, required this.title});
  final String title;

  @override
  State<PdfUploadPage> createState() => _PdfUploadPageState();
}

class _PdfUploadPageState extends State<PdfUploadPage> {
  Future<void> _addPdfFile() async {
    // PDFファイルの選択
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      String selectedFilePath = result.files.single.path!;
      File selectedFile = File(selectedFilePath);

      // プロジェクトのルートディレクトリを取得
      String projectRootPath = Directory.current.path;
      String targetDirectory = '$projectRootPath/lib/data/pdf';

      // ターゲットディレクトリが存在しない場合は作成
      Directory(targetDirectory).createSync(recursive: true);

      String newFilePath = '$targetDirectory/selected_pdf.pdf';

      // ファイルを新しい場所にコピー
      await selectedFile.copy(newFilePath);

      // 成功メッセージを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDFファイルが保存されました: $newFilePath")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ファイルが選択されませんでした")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 背景にGIFを配置
          Positioned(
            left: 0,
            bottom: 0,
            child: Image(
              image: AssetImage('images/dance.gif'),
              fit: BoxFit.cover,
            ),
          ),
          // 中央のコンテンツ
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('images/title.png'),
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 160),
                ElevatedButton(
                  onPressed: _addPdfFile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text(
                    'Upload PDF',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

