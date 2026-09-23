import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const RMSApp());

class RMSApp extends StatelessWidget {
  const RMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RMS Communications',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315BFF)),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int tab = 0;

  final pages = const [
    _HomeTab(),
    RechargePage(),
    _WalletTab(),
    _TransactionsTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.phone_android), label: 'Recharge'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF1F5FA),
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text('RMS Communications', style: TextStyle(fontWeight: FontWeight.w900)),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [Color(0xFF1D63F5), Color(0xFF7B20E8)]),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome 👋', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 5),
            Text('RMS Communications', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            SizedBox(height: 18),
            Text('Available Balance', style: TextStyle(color: Colors.white70)),
            Text('₹0.00', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
          ]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _Action(title: 'Recharge', icon: Icons.phone_android, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RechargePage())))),
          const SizedBox(width: 12),
          Expanded(child: _Action(title: 'Add Money', icon: Icons.add_card, onTap: () {})),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _Metric(title: 'Today Sales', value: '₹0')),
          const SizedBox(width: 12),
          Expanded(child: _Metric(title: 'Commission', value: '₹0')),
        ]),
        const SizedBox(height: 20),
        const Text('Services', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const _Service(icon: Icons.phone_android, title: 'Mobile Recharge', sub: 'Jio • Airtel • Vi • BSNL'),
        const _Service(icon: Icons.tv, title: 'DTH Recharge', sub: 'DTH service'),
        const _Service(icon: Icons.receipt_long, title: 'Bill Payments', sub: 'Utility payments'),
        const _Service(icon: Icons.people_alt_outlined, title: 'Agent Commission', sub: 'View earnings'),
      ],
    ),
  );
}

class _Action extends StatelessWidget {
  final String title; final IconData icon; final VoidCallback onTap;
  const _Action({required this.title, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [Icon(icon, size: 30, color: const Color(0xFF315BFF)), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w800))]),
    ),
  );
}

class _Metric extends StatelessWidget {
  final String title, value;
  const _Metric({required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
    ]),
  );
}

class _Service extends StatelessWidget {
  final IconData icon; final String title, sub;
  const _Service({required this.icon, required this.title, required this.sub});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
    child: Row(children: [
      CircleAvatar(backgroundColor: const Color(0xFFEAF0FF), child: Icon(icon, color: const Color(0xFF315BFF))),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), Text(sub, style: const TextStyle(color: Colors.grey))]),
    ]),
  );
}

class _WalletTab extends StatelessWidget {
  const _WalletTab();
  @override
  Widget build(BuildContext context) => _SimplePage(title: 'Wallet', children: [
    const _BigValue(label: 'Available Balance', value: '₹0.00'),
    const SizedBox(height: 14),
    _ListTile(icon: Icons.add_card, title: 'Add Money', sub: 'Add credit to your wallet', onTap: () {}),
    _ListTile(icon: Icons.account_balance_wallet, title: 'Wallet Ledger', sub: 'View credits and debits', onTap: () {}),
    _ListTile(icon: Icons.percent, title: 'Commission', sub: 'View your earnings', onTap: () {}),
  ]);
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab();
  @override
  Widget build(BuildContext context) => _SimplePage(title: 'Transaction History', children: [
    _ListTile(icon: Icons.receipt_long, title: 'No transactions yet', sub: 'Your recharge history will appear here', onTap: () {}),
  ]);
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) => _SimplePage(title: 'Profile', children: [
    const _BigValue(label: 'RMS Communications', value: 'Agent Account'),
    _ListTile(icon: Icons.verified_user_outlined, title: 'KYC / Account', sub: 'Account verification', onTap: () {}),
    _ListTile(icon: Icons.support_agent, title: 'Support', sub: 'Contact support', onTap: () {}),
    _ListTile(icon: Icons.settings_outlined, title: 'Settings', sub: 'App preferences', onTap: () {}),
    _ListTile(icon: Icons.logout, title: 'Logout', sub: 'Sign out of this account', onTap: () {}),
  ]);
}

class _SimplePage extends StatelessWidget {
  final String title; final List<Widget> children;
  const _SimplePage({required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF1F5FA),
    appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
    body: ListView(padding: const EdgeInsets.all(16), children: children),
  );
}

class _BigValue extends StatelessWidget {
  final String label, value;
  const _BigValue({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(colors: [Color(0xFF1D63F5), Color(0xFF7B20E8)]),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
    ]),
  );
}

class _ListTile extends StatelessWidget {
  final IconData icon; final String title, sub; final VoidCallback onTap;
  const _ListTile({required this.icon, required this.title, required this.sub, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF315BFF)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(sub),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});
  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final number = TextEditingController();
  final amount = TextEditingController();
  int provider = 2;
  bool loading = false;
  String message = '';

  // Change this to your deployed backend URL before release.
  static const backend = 'http://10.0.2.2:3000';

  Future<void> recharge() async {
    if (!RegExp(r'^\d{10}$').hasMatch(number.text) || amount.text.isEmpty) {
      setState(() => message = 'Enter a valid 10-digit mobile number and amount.');
      return;
    }
    setState(() { loading = true; message = ''; });
    try {
      final res = await http.post(
        Uri.parse('$backend/api/recharge'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'number': number.text,
          'provider_id': provider,
          'amount': double.tryParse(amount.text) ?? 0,
          'type': 'MOBILE'
        }),
      );
      final data = jsonDecode(res.body);
      setState(() => message = data['message']?.toString() ?? 'Recharge request submitted.');
    } catch (e) {
      setState(() => message = 'Backend connection failed. Check your server URL.');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF3F6FA),
    appBar: AppBar(title: const Text('New Recharge', style: TextStyle(fontWeight: FontWeight.bold))),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Mobile Recharge', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('Recharge through RMS Communications'),
        const SizedBox(height: 24),
        TextField(
          controller: number,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            prefixIcon: Icon(Icons.phone_android),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          value: provider,
          decoration: const InputDecoration(
            labelText: 'Operator',
            prefixIcon: Icon(Icons.sim_card),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
          ),
          items: const [
            DropdownMenuItem(value: 2, child: Text('Jio')),
            DropdownMenuItem(value: 1, child: Text('Airtel')),
            DropdownMenuItem(value: 3, child: Text('Vi')),
            DropdownMenuItem(value: 4, child: Text('BSNL')),
          ],
          onChanged: (v) => setState(() => provider = v ?? 2),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: amount,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Recharge Amount',
            prefixText: '₹ ',
            prefixIcon: Icon(Icons.currency_rupee),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: loading ? null : recharge,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: const Color(0xFF315BFF),
              foregroundColor: Colors.white,
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Recharge Now', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Text(message),
          )
        ]
      ],
    ),
  );
}
