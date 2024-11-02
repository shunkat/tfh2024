import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data' show Uint8List;

import '../upload/upload_pdf_view.dart';

class PDFViewerScreen extends StatefulWidget {
  final PdfViewerArguments arguments;

  const PDFViewerScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  int _totalPages = 0;
  late Uint8List _pdfData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pdfData = widget.arguments.pdfData;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousPage() {
    if (_currentPage > 0 && _pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1 && _pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  ///todo クラスで切り出して欲しい
  Widget _buildPageView(List<PdfPreviewPageData> pages) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Image(image: pages[index].image),
        );
      },
    );
  }

  ///todo クラスで切り出して欲しい
  Widget _buildNavigationBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: _currentPage > 0 ? _previousPage : null,
              backgroundColor: _currentPage > 0 ? Colors.blue : Colors.grey,
              child: const Icon(Icons.navigate_before),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Page ${_currentPage + 1} of $_totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
              backgroundColor:
                  _currentPage < _totalPages - 1 ? Colors.blue : Colors.grey,
              child: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview.builder(
        build: (format) => Future.value(_pdfData),
        pagesBuilder: (context, pages) {
          _totalPages = pages.length;
          return Stack(
            children: [
              _buildPageView(pages),
              _buildNavigationBar(),
            ],
          );
        },
      ),
    );
  }
}
