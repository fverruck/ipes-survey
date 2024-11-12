import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'survey_provider.dart';
import 'home_page.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB0h9I5lOfnmEe9eEpdLXWqry2vstxRqjg",
        authDomain: "ipes-survey.firebaseapp.com",
        projectId: "ipes-survey",
        storageBucket: "ipes-survey.firebasestorage.app",
        messagingSenderId: "257463114401",
        appId:"1:257463114401:web:ff8fb77ac38ed8130ceee0",
        measurementId: "G-TV79B2334V",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
      child: MaterialApp(
        title: 'Survey App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}