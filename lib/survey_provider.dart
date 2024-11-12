import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html if (dart.library.html) 'dart:html';  // Import `html` only if running on the web

class SurveyProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _questions = [
    {
      'question': 'Quem é o melhor de todos?',
      'type': 'multiple-choice',
      'options': ['Fábio Verruck', 'Pai da Stella', 'Marido da Raquel', 'Todas as alternativas']
    },
    {
      'question': 'Por que o Fábio é tão maravilhoso?',
      'type': 'multiple-choice',
      'options': ['Por causa da sua inteligência superior', 'Por causa da sua beleza superior', 'Por que ele passou a noite inteira acordado para criar este app', 'Todas as alternativas']
    },
    {
      'question': 'O que o Fábio vai ganhar por ser tão legal?',
      'type': 'multiple-choice',
      'options': ['Um Latte na sua mesa às 14h quando chegar', 'O melhor vinho da adega do tio Birch', 'Um presente supimpa', 'Todas as alternativas']
    },
       {
      'question': 'Você acha que o Fábio deveria ganhar o título de melhor do mundo?',
      'type': 'yes-no',
      'options': ['Sim', 'Não']
    },
       {
      'question': 'Indique os cinco principais motivos por que o Fábio é tão perfeito:',
      'type': 'open',
    }
  ];

  int _currentQuestionIndex = 0;
  Map<int, String> _responses = {};

  int get currentQuestionIndex => _currentQuestionIndex;
  Map<String, dynamic> get currentQuestion => _questions[_currentQuestionIndex];
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  Map<int, String> get responses => _responses;
  List<Map<String, dynamic>> get questions => _questions;

  void selectOption(String option) {
    _responses[_currentQuestionIndex] = option;
    notifyListeners();
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void addQuestion(String questionText, List<String> options) {
    _questions.add({
      'question': questionText,
      'options': options,
    });
    notifyListeners();
  }

  Future<void> submitSurvey() async {
    // Convert the Map<int, String> to Map<String, String>
    final responsesJson = jsonEncode(
        _responses.map((key, value) => MapEntry(key.toString(), value)));

        // Handle Web vs Mobile/Desktop file storage
    if (kIsWeb) {
      // For Web: trigger a file download
      final bytes = utf8.encode(responsesJson);
      final blob = html.Blob([Uint8List.fromList(bytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'survey_responses.json';
      anchor.click();
      html.Url.revokeObjectUrl(url);
      print("Survey data downloaded on Web");
    } else {
      // For Mobile/Desktop: use path_provider to get the document directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/survey_responses.json');
      await file.writeAsString(responsesJson);
      print("Survey data saved locally at ${file.path}");
    }

    try {
    final firestoreResponses = _responses.map((key, value) => MapEntry(key.toString(), value));
    await FirebaseFirestore.instance.collection('surveys').add({
      'responses': firestoreResponses,
      'submittedAt': Timestamp.now(),
    });
      print("Survey saved to Firestore");
    } catch (e) {
      print("Failed to save survey: ${e.toString()}");
    }
  }

  // Add resetSurvey to reset responses and question index
  void resetSurvey() {
    _currentQuestionIndex = 0;
    _responses.clear();
    notifyListeners();
  }
}
