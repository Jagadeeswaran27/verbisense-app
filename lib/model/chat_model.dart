class Points {
  Map<String, List<String>> points;

  Points({required this.points});

  factory Points.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> pointsMap = {};
    json.forEach((key, value) {
      // Safely convert dynamic values to List<String>
      pointsMap[key] = List<String>.from(value ?? []);
    });
    return Points(points: pointsMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> pointsMap = {};
    points.forEach((key, value) {
      pointsMap[key] = value;
    });
    return pointsMap;
  }
}

class ChatModel {
  String query;
  String? heading1;
  List<String> heading2;
  String keyTakeaways;
  Points points;
  List<String> example;
  String summary;
  String error;

  ChatModel({
    required this.query,
    this.heading1,
    required this.heading2,
    required this.keyTakeaways,
    required this.points,
    required this.example,
    required this.summary,
    required this.error,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      query: json['query'],
      heading1: json['heading1'],
      // Safe conversion from dynamic list to List<String>
      heading2: List<String>.from(json['response']['heading2'] ?? []),
      keyTakeaways: json['response']['key_takeaways'] ?? "",
      points: Points.fromJson(json['response']['points'] ?? {}),
      // Safe conversion from dynamic list to List<String>
      example: List<String>.from(json['response']['example'] ?? []),
      summary: json['response']['summary'] ?? "",
      error: json['error'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'heading1': heading1,
      'heading2': heading2,
      'key_takeaways': keyTakeaways,
      'points': points.toJson(),
      'example': example,
      'summary': summary,
      'error': error,
    };
  }
}
