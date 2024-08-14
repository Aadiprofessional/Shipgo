import 'package:flutter/material.dart';


class CompanyDetail extends StatelessWidget {
  final Map<String, dynamic> company;
  final Function(String) onRemove;

  CompanyDetail({required this.company, required this.onRemove});

  void _handleRemove() async {
    try {
      // Simulate API request to remove company
      await Future.delayed(Duration(seconds: 1));

      onRemove(company['id']);
   
    } catch (e) {
   
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: company['type'] == 'Primary' ? Colors.blue : Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (company['type'] == 'Added')
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: _handleRemove,
              ),
            ),
          if (company['type'] == 'Primary')
            Text('Primary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
          Text('Company: ${company['name']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Address: ${company['address'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
          Text('GST: ${company['gst'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
          Text('Owner: ${company['owner'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
