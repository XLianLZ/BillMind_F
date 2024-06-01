import 'package:flutter/material.dart';
import 'package:nav_bar/pages/principal/alerts_page.dart';
import 'package:nav_bar/pages/principal/balance_page.dart';
import 'package:nav_bar/pages/principal/debts_page.dart';
import 'package:nav_bar/pages/principal/profile_page.dart';

import 'pages/sessions/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class  MyHomePage extends StatefulWidget {
  final String token;
  final int clientId;

  const MyHomePage({super.key, required this.token, required this.clientId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBar Example'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DebtsPage( clientId: widget.clientId),
          AlertsPage(),
          BalancePage(),
          ProfilePage(clientId: widget.clientId),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.money), text: 'Debts'), 
          Tab(icon: Icon(Icons.notifications), text: 'Alerts'),
          Tab(icon: Icon(Icons.account_balance), text: 'Balance'),
          Tab(icon: Icon(Icons.person), text: 'Profile'),
        ],
      ),
    );
  }
}