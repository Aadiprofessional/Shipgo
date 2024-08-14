import 'package:flutter/material.dart';

class AttributesSelector extends StatelessWidget {
  final List<Map<String, String>> attributeData;
  final String selectedValue;
  final Function(String) onSelect;
  final String attributeName;

  AttributesSelector({
    required this.attributeData,
    required this.selectedValue,
    required this.onSelect,
    required this.attributeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$attributeName:',
            style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: attributeData.map((item) {
              bool isSelected = selectedValue == item['value'];
              return GestureDetector(
                onTap: () => onSelect(item['value']!),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF25424D) : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Color(0xFFB3B3B3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['label']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Color(0xFF333333),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
