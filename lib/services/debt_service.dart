import 'dart:async';
import 'dart:convert';

import 'package:nav_bar/models/debt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class DebtService {
  static const String baseUrl='http://10.0.2.2:8080/api/v1/debts';

  final storage = FlutterSecureStorage();

  Future<List<Debt>> getDebtsByClientId(int clientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/clients/$clientId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Debt> debts = body.map((dynamic item) => Debt.fromJson(item)).toList();
        return debts;
      } else {
        throw Exception('Failed to load debts: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (_) {
      throw Exception('Request to $baseUrl/client/$clientId timed out');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }

  }
}