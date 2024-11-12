import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'survey_provider.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thank you for completing the survey!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reset the survey data
                Provider.of<SurveyProvider>(context, listen: false).resetSurvey();
                
                // Navigate back to HomePage by popping all routes
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Start New Survey'),
            ),
          ],
        ),
      ),
    );
  }
}