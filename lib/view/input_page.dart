import 'package:flutter/material.dart';
import 'package:mind_typing/view/components/custom_app_bar.dart';
import 'package:mind_typing/view/typing_practice_page.dart';

class InputPage extends StatelessWidget {
  InputPage({super.key});
  
  final TextEditingController _practiceTextController = TextEditingController();

  void _startPractice(BuildContext context) {
    if (_practiceTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: 
          Text('Please enter some text to practice')),
      );
      return;
    }
    String practiceText = _practiceTextController.text;
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => TypingPracticePage(practiceText: practiceText),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: CustomAppBar()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              TextField(
                controller: _practiceTextController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:  'Enter or paste the text you want to practice typing...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (){_startPractice(context);},
                child: Text('Start Practice', style: Theme.of(context).textTheme.titleMedium,),
              )
          ]
        )
      )     
    );
  }
}
