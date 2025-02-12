import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String applicationId;
  final String restApiKey;

  ApiService({
    required this.baseUrl,
    required this.applicationId,
    required this.restApiKey,
  });

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao fazer requisição POST: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao fazer requisição GET: ${response.body}');
    }
  }
}
