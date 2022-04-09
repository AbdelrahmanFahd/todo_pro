import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedScreen extends StatelessWidget {
  const NotifiedScreen({Key? key, required this.label}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back,
          ),
          title: Text(label.split('|')[0])),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[400],
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              label.split('|')[1],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
