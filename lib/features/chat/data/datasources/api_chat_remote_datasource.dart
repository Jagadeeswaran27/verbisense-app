import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/error/exceptions.dart';

abstract class ApiChatRemoteDatasource {
  Future<void> sendMessage(String query, List<String> files, String? date);
}

class ApiChatRemoteDatasourceImpl implements ApiChatRemoteDatasource {
  final String baseUrl = 'https://api.verbisense.com/api/v1/chat';
  @override
  Future<void> sendMessage(
    String query,
    List<String> files,
    String? date,
  ) async {
    final url = Uri.parse('$baseUrl/chat');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'query': query,
          'files': files,
          'date': date,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Status code mismatch, Recieved:${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);
      AppLogger.i(data.toString());
    } catch (e) {
      throw ServerException('Failed to send message: $e');
    }
  }
}
