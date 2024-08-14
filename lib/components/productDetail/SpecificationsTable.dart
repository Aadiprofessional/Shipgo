import 'package:flutter/material.dart';

class SpecificationsTable extends StatelessWidget {
  final List<Map<String, String>> specifications;

  SpecificationsTable({required this.specifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
              
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: specifications.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> spec = entry.value;
                return Container(
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Color(0xFFF7F7F7) : Color(0xFFE0E0E0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        spec['label']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        spec['value']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
