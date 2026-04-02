class HistoryModel {
  final String cid;
  final String? heading1;

  HistoryModel({
    required this.cid,
    this.heading1,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      cid: json['cid'],
      heading1: json['heading1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'heading1': heading1,
    };
  }

  HistoryModel copyWith({
    String? cid,
    String? heading1,
  }) {
    return HistoryModel(
      cid: cid ?? this.cid,
      heading1: heading1 ?? this.heading1,
    );
  }
}
