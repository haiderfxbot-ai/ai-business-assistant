import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/customer_provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_add), onPressed: () {}),
        ],
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, customerProvider, _) {
          if (customerProvider.isLoading) return const Center(child: CircularProgressIndicator());
          if (customerProvider.customers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No customers yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: customerProvider.customers.length,
            itemBuilder: (_, i) {
              final customer = customerProvider.customers[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.secondaryColor,
                  child: Text(customer.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                ),
                title: Text(customer.name),
                subtitle: Text(customer.phoneNumber ?? 'No phone', style: TextStyle(color: Colors.grey[600])),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${customer.totalOrders} orders', style: const TextStyle(fontSize: 12)),
                    Text('\u20B9${customer.totalSpent.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: Colors.green[600])),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
