import 'package:flutter/material.dart';
import 'package:nav_bar/models/client.dart';
import 'package:nav_bar/services/client_service.dart';

class ProfilePage extends StatelessWidget {
  final int clientId;

  const ProfilePage({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Client>(
        future: fetchClient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final client = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${client.name}'),
                  Text('Last Name: ${client.lastName}'),
                  Text('Email: ${client.mail}'),
                  Text('Phone: ${client.phone}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Client> fetchClient() async {
    final service = ClientService();
    final client = await service.getClientById(clientId, clientId: 1);
    return client;
  }
}