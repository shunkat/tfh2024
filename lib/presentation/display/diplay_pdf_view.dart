import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({super.key});

  Future<Uint8List> _loadPdf() async {
    final ByteData data = await rootBundle.load('assets/sample.pdf');
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Stack(children: [
        PdfPreview(
          build: (format) => _loadPdf(),
        ),
        Text(
          'AAAAAAAAAAAA',
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ]),
    );
  }
}
