import 'package:flutter/material.dart';
import 'survey_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Survey App'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Start Survey'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SurveyPage()),
            );
          },
        ),
      ),
    );
  }
}