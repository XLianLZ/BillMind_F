import 'dart:async';
import 'dart:convert';

import 'package:nav_bar/models/client.dart';
import 'package:http/http.dart' as http;

class ClientService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/clients';

  Future<List<Client>> getClients() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Client> clients = body.map((dynamic item) => Client.fromJson(item)).toList();
        return clients;
      } else {
        throw Exception('Failed to load clients: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (_) {
      throw Exception('Request to $baseUrl timed out');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  //genera una funcion que trae un cliente por id
  Future<Client> getClientById(int id, {required int clientId}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Client.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load client: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (_) {
      throw Exception('Request to $baseUrl timed out');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}