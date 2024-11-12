import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'survey_provider.dart';
import 'result_page.dart'; // Add this import

class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Question ${surveyProvider.currentQuestionIndex + 1}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surveyProvider.currentQuestion['question'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            _buildQuestionWidget(surveyProvider),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!surveyProvider.isLastQuestion)
                  ElevatedButton(
                    onPressed: () {
                      surveyProvider.nextQuestion();
                    },
                    child: Text('Next'),
                  ),
                if (surveyProvider.isLastQuestion)
                  ElevatedButton(
                    onPressed: () async {
                      await surveyProvider.submitSurvey();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ResultPage()),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(SurveyProvider surveyProvider) {
    final questionType = surveyProvider.currentQuestion['type'];
    final questionOptions = surveyProvider.currentQuestion['options'] ?? [];

    switch (questionType) {
      case 'multiple-choice':
        return Column(
          children: questionOptions.map<Widget>((option) {
            return ListTile(
              title: Text(option),
              leading: Radio(
                value: option,
                groupValue: surveyProvider.responses[surveyProvider.currentQuestionIndex],
                onChanged: (value) {
                  surveyProvider.selectOption(value as String);
                },
              ),
            );
          }).toList(),
        );
      case 'yes-no':
        return Column(
          children: ['Sim', 'Não'].map<Widget>((option) {
            return ListTile(
              title: Text(option),
              leading: Radio(
                value: option,
                groupValue: surveyProvider.responses[surveyProvider.currentQuestionIndex],
                onChanged: (value) {
                  surveyProvider.selectOption(value as String);
                },
              ),
            );
          }).toList(),
        );
      case 'open':
        return TextField(
          onChanged: (value) {
            surveyProvider.selectOption(value);
          },
          decoration: InputDecoration(
            labelText: 'Digite sua resposta',
            border: OutlineInputBorder(),
          ),
        );
      default:
        return Text('Tipo de pergunta não suportado');
    }
  }
}
