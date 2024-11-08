import 'package:cloud_firestore/cloud_firestore.dart';

import 'commentModel.dart';

class CommentsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 特定のPDFのコメントを取得（リアルタイム）
  Stream<List<Comment>> getCommentsForPdf(String pdfId) {
    return _firestore
        .collection('pdfs')
        .doc(pdfId)
        .collection('goodComments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
    });
  }

  // コメントの削除
  Future<void> deleteComment(String pdfId, String commentId) async {
    await _firestore
        .collection('pdfs')
        .doc(pdfId)
        .collection('goodComments')
        .doc(commentId)
        .delete();
  }
}
