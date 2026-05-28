import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../config/theme.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.id.substring(0, 8)}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status', style: TextStyle(color: Colors.grey[600])),
                        Chip(
                          label: Text(order.statusText, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: order.status == OrderStatus.delivered ? Colors.green
                            : order.status == OrderStatus.cancelled ? Colors.red
                            : Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Customer: ${order.customerName}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Total: \u20B9${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Items', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            ...order.items.map((item) => Card(
              child: ListTile(
                title: Text(item.name),
                trailing: Text('\u20B9${item.total.toStringAsFixed(2)}'),
                subtitle: Text('Qty: ${item.quantity} x \u20B9${item.price.toStringAsFixed(2)}'),
              ),
            )),
            if (order.notes != null) ...[
              const SizedBox(height: 16),
              Text('Notes', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(order.notes!))),
            ],
          ],
        ),
      ),
    );
  }
}
