import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String cid;
  final String error;
  final String keyTakeaways;
  final String query;
  final String summary;
  final List<String> heading2;
  final Map<String, dynamic> points;
  final Timestamp timestamp;
  final String? heading1;

  Chat({
    required this.cid,
    required this.error,
    required this.keyTakeaways,
    required this.query,
    required this.summary,
    required this.heading2,
    required this.points,
    required this.timestamp,
    this.heading1,
  });
}
