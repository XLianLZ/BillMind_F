import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/auth';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<Map<String, dynamic>> login(String mail, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: defaultHeaders,
      body: jsonEncode(<String, String>{
        'mail': mail,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Response headers: ${response.headers}');
    print('Client id: ${response.headers['client_id']}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      final String accessToken = responseBody['accessToken']; // Cambiado de 'token' a 'accessToken'
      int? clientId;
      final String? clientIdHeader = response.headers['client_id'];
      if (clientIdHeader != null) {
        clientId = int.tryParse(clientIdHeader);
      } else {
        throw Exception('Client id is missing in response headers');
      }

      if (accessToken.isEmpty || clientId == null) { // Revisa si el accessToken está vacío o el clientId es nulo
        throw Exception('Token or client_id is null or empty');
      }

      return {
        'token': accessToken,
        'clientId': clientId,
      };
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Network error: $e');
  } on TimeoutException catch (_) {
    throw Exception('Request to $baseUrl timed out');
  } catch (e) {
    throw Exception('An unknown error occurred: $e');
  }
}

  Future<void> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _buildAuthHeaders(token),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 204) {
        _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      throw Exception('Error de red: $e');
    } on TimeoutException catch (_) {
      throw Exception('La solicitud a $baseUrl agotó el tiempo');
    } catch (e) {
      throw Exception('Ocurrió un error desconocido: $e');
    }
  }

  Future<void> register(String name, String lastName, String phone, String mail, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: defaultHeaders,
        body: jsonEncode(<String, String>{
          'name': name,
          'last_name': lastName,
          'phone': phone,
          'mail': mail,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 201) {
        _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      throw Exception('Error de red: $e');
    } on TimeoutException catch (_) {
      throw Exception('La solicitud a $baseUrl agotó el tiempo');
    } catch (e) {
      throw Exception('Ocurrió un error desconocido: $e');
    }
  }

  Map<String, String> _buildAuthHeaders(String token) {
    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  void _handleErrorResponse(http.Response response) {
    final errorResponse = jsonDecode(response.body);
    throw Exception('Error: ${errorResponse['message'] ?? response.reasonPhrase}');
  }
}