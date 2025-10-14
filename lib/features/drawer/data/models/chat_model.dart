import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:verbisense/core/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required super.cid,
    required super.error,
    required super.keyTakeaways,
    required super.query,
    required super.summary,
    required super.heading2,
    required super.points,
    required super.timestamp,
    super.heading1,
  });

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      cid: map['cid'] ?? '',
      error: map['error'] ?? '',
      keyTakeaways: map['key_takeaways'] ?? '',
      query: map['query'] ?? '',
      summary: map['summary'] ?? '',
      heading2: List<String>.from(map['heading2'] ?? []),
      points: Map<String, dynamic>.from(map['points'] ?? {}),
      timestamp: map['timestamp'],
      heading1: map['heading1'],
    );
  }

  ChatModel copyWith({
    String? id,
    String? error,
    String? keyTakeaways,
    String? query,
    String? summary,
    List<String>? heading2,
    Map<String, dynamic>? points,
    Timestamp? timestamp,
    String? heading1,
  }) {
    return ChatModel(
      cid: cid,
      error: error ?? this.error,
      keyTakeaways: keyTakeaways ?? this.keyTakeaways,
      query: query ?? this.query,
      summary: summary ?? this.summary,
      heading2: heading2 ?? this.heading2,
      points: points ?? this.points,
      timestamp: timestamp ?? this.timestamp,
      heading1: heading1 ?? this.heading1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'error': error,
      'key_takeaways': keyTakeaways,
      'query': query,
      'summary': summary,
      'heading2': heading2,
      'points': points,
      'timestamp': timestamp,
      if (heading1 != null) 'heading1': heading1,
    };
  }
}
