import 'package:flutter/material.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final adminOrderProvider = Provider.of<AdminOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
    );
  }
}
