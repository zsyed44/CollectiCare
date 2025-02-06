import 'package:flutter/material.dart';

class Test1 extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<Test1> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> answers = {};

  // Define your questions here
  final List<Map<String, dynamic>> questions = [
    {
      'id': 'q1',
      'question': 'Have you noticed any changes in your vision recently?',
      'type': 'long_text',
    },
    {
      'id': 'q2',
      'question': 'Do you experience blurry vision, either up close or far away?',
      'type': 'long_text',
    },
    {
      'id': 'q3',
      'question': 'Do you experience frequent headaches, eye strain, or discomfort when reading or using screens?',
      'type': 'long_text',
    },
    {
      'id': 'q4',
      'question': 'Have you had any eye injuries or surgeries in the past?',
      'type': 'long_text',
    },
    {
      'id': 'q5',
      'question': 'Do you see double or have difficulty focusing on objects?',
      'type': 'long_text',
    },
  ];

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initial Questioner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Introduction text
                Text(
                  'Please answer the following questions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Questions
                ...questions.map((question) => _buildQuestionItem(question)).toList(),

                SizedBox(height: 20),

                // Submit button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionItem(Map<String, dynamic> question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question text
        Text(
          question['question'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),

        // Answer input field
        TextFormField(
          maxLines: question['type'] == 'long_text' ? 3 : 1,
          decoration: InputDecoration(
            hintText: 'Enter your answer here',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide an answer';
            }
            return null;
          },
          onSaved: (value) {
            answers[question['id']] = value ?? '';
          },
        ),
        SizedBox(height: 24),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Here you can handle the answers
      print('Form Submitted!');
      answers.forEach((questionId, answer) {
        print('$questionId: $answer');
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for completing the questionnaire!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // Return true when submitted
    }
  }
}
  