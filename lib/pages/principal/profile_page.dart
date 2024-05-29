import 'package:flutter/material.dart';
import 'package:nav_bar/models/client.dart';
import 'package:nav_bar/services/client_service.dart';

class ProfilePage extends StatefulWidget {
  final int clientId;

  const ProfilePage({super.key, required this.clientId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Client> _client;

  @override
  void initState() {
    super.initState();
    _client = fetchClient();
  }

  Future<Client> fetchClient() async {
    final service = ClientService();
    final client = await service.getClientById(widget.clientId, clientId: 1);
    return client;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Client>(
      future: _client,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final client = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Name: ${client.name}'),
              Text('Email: ${client.mail}'),
              Text('Phone: ${client.phone}'),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}