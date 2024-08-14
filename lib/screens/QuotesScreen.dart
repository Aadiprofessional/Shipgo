import 'package:flutter/material.dart';


class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  bool isLoading = true;
  List<dynamic> quotes = [];
  String selectedType = 'quotes';

  @override
  void initState() {
    super.initState();
  
  }

 

  

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedType = value;
              });
          
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'quotes', child: Text('Quotes')),
              PopupMenuItem(value: 'orders', child: Text('Orders')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return ListTile(
            title: Text('Quote #${quote['id']}'),
          
          );
        },
      ),
    );
  }
}
