import 'package:flutter/material.dart';
import '../config/theme.dart';

class AISuggestionBar extends StatelessWidget {
  const AISuggestionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Price kya hai?',
      'Product details batao',
      'Order status',
      'Contact info',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 14, color: AppTheme.secondaryColor),
              const SizedBox(width: 4),
              Text('AI Suggestions', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(s, style: const TextStyle(fontSize: 12)),
                  onPressed: () {},
                  backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                  side: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.3)),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
