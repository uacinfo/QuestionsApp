// lib/main.dart

import 'package:flutter/material.dart';
import 'question.dart'; // Import the Question model

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;

  // List of questions
  List<Question> questions = [
    Question(
      questionText: 'What is the capital of France?',
      options: ['Paris', 'London', 'Berlin', 'Madrid'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
      correctAnswerIndex: 1,
    ),
    // Add more questions here
  ];

  void _nextQuestion() {
    if (selectedOptionIndex != null &&
        questions[currentQuestionIndex].correctAnswerIndex ==
            selectedOptionIndex) {
      score++;
    }

    setState(() {
      currentQuestionIndex++;
      selectedOptionIndex = null;
    });
  }

  void _skipQuestion() {
    setState(() {
      currentQuestionIndex++;
      selectedOptionIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz App')),
        body: Center(child: Text('Your score: $score/${questions.length}')),
      );
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ...currentQuestion.options.asMap().entries.map((option) {
              return ListTile(
                title: Text(option.value),
                leading: Radio<int>(
                  value: option.key,
                  groupValue: selectedOptionIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedOptionIndex = value;
                    });
                  },
                ),
              );
            }).toList(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: selectedOptionIndex == null ? null : _nextQuestion,
                  child: Text('Select'),
                ),
                ElevatedButton(
                  onPressed: _skipQuestion,
                  child: Text('Skip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
