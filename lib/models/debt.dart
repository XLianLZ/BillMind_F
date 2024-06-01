import 'package:nav_bar/models/client.dart';

class Debt {
  final int id;
  final String expiration;
  final String amount;
  final String description;
  final String relevance;
  final Client client;

  Debt({
    required this.id,
    required this.expiration,
    required this.amount,
    required this.description,
    required this.relevance,
    required this.client,
  });

  Debt.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        expiration = json['expiration'],
        amount = json['amount'],
        description = json['description'],
        relevance = json['relevance'],
        client = Client.fromJson(json['client']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'expiration': expiration,
        'amount': amount,
        'description': description,
        'relevance': relevance,
        'client': client.toJson(),
      };
}