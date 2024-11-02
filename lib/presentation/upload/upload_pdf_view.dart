import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data' show Uint8List;

import '../display/diplay_pdf_view.dart';

class PdfViewerArguments {
  final Uint8List pdfData;
  final String? fileName;

  PdfViewerArguments({
    required this.pdfData,
    this.fileName,
  });
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
              builder: (context) => PDFViewerScreen(
                arguments: PdfViewerArguments(
                  pdfData: pdfData,
                  fileName: fileName,
                ),
              ),
            ),
          );
          return;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading PDF: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload PDF'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: 64,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select PDF file to view',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Supported format: PDF',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickPDF,
                  icon: _isLoading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.upload_file),
                  label: Text(_isLoading ? 'Loading...' : 'Upload PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
