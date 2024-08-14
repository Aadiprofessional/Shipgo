import 'package:flutter/material.dart';
import 'package:shipgo/components/CompanyDetail.dart';


class CompanyList extends StatefulWidget {
  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  List<Map<String, dynamic>> companies = [
    {
      'id': '1',
      'name': 'Company A',
      'address': '123 Street',
      'gst': 'GST1234',
      'owner': 'Owner A',
      'type': 'Primary',
    },
    {
      'id': '2',
      'name': 'Company B',
      'address': '456 Avenue',
      'gst': 'GST5678',
      'owner': 'Owner B',
      'type': 'Added',
    },
  ];

  void _removeCompany(String id) {
    setState(() {
      companies.removeWhere((company) => company['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companies'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: companies.map((company) {
            return CompanyDetail(company: company, onRemove: _removeCompany);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add company logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
