import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String pdfId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.pdfId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      pdfId: doc.reference.parent.parent!.id, // コレクショングループを使用する場合
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
