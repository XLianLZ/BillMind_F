import 'package:flutter/material.dart';
import 'package:nav_bar/models/debt.dart';
import 'package:nav_bar/services/debt_service.dart';

class DebtsPage extends StatefulWidget {
  final int clientId;

  const DebtsPage({Key? key, required this.clientId}) : super(key: key);

  @override
  _DebtsPageState createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  late Future<List<Debt>> _futureDebts;

  @override
  void initState() {
    super.initState();
    _futureDebts = DebtService().getDebtsByClientId(widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debts Page'),
      ),
      body: FutureBuilder<List<Debt>>(
        future: _futureDebts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron deudas para este cliente'));
          } else {
            List<Debt> debts = snapshot.data!;
            return ListView.builder(
              itemCount: debts.length,
              itemBuilder: (context, index) {
                Debt debt = debts[index];
                return ListTile(
                  title: Text(debt.description),
                  subtitle: Text('Monto: ${debt.amount} | Vence: ${debt.expiration}'),
                  trailing: Text('Relevancia: ${debt.relevance}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
