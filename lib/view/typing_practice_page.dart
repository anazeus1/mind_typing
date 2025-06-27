import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_typing/view/components/custom_app_bar.dart';
import 'dart:ui';

class TypingPracticePage extends StatefulWidget {
  final String practiceText;
  const TypingPracticePage({super.key, required this.practiceText});
  @override
  State<TypingPracticePage> createState() => _TypingPracticePageState();
}

class _TypingPracticePageState extends State<TypingPracticePage> {
  String _currentInput = "";
  String _practiceText = "";
  final TextEditingController _typingController = TextEditingController();

  //starting index of each word
  final List<int> _wordIndexList = [];
  int _lastWordLength = 0;

  final FocusNode _focusNode = FocusNode();
  bool _isBlurred = false;
  //stats
  int _totalCharactersCorrect = 0;
  int _startTime = 0;
  int _pausedTime = 0;
  double _wpm = 0.0;
  double _accuracy = 0.0;

  @override
  void initState() {
    super.initState();

    _practiceText = widget.practiceText;
    initWordIndexList();

    _typingController.addListener(_onTypingChanged);
    _typingController.addListener(() {
      if (_practiceText.length == _currentInput.length) {
        _endPractice();
      }
    });

    //arrow keys are ignored in input
    _focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };

    //blur when curso not in TerxtFIeld
    _focusNode.addListener(() {
      setState(() {
        _isBlurred = !_focusNode.hasFocus;
        if (!_focusNode.hasFocus) {
          _pausedTime = DateTime.now().millisecondsSinceEpoch;
        } else if (_pausedTime > 0) {
          _startTime += DateTime.now().millisecondsSinceEpoch - _pausedTime;
          _pausedTime = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _typingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void initWordIndexList() {
    for (int i = 0; i < _practiceText.length; i++) {
      if (_practiceText[i] == ' ') {
        _wordIndexList.add(i);
      }
    }
  }

  void _onTypingChanged() {
    setState(() {
      _currentInput = _typingController.text;
    });
    if (_startTime == 0) {
      _startTime = DateTime.now().millisecondsSinceEpoch;
    }
    //find out how many more characters are needed to complete the last word
    //this is done to avoid characters hanging at the end of a line
    int lastWordindex = _wordIndexList.firstWhere(
      (key) => key > _currentInput.length - 1,
      orElse: () => 0,
    );
    _lastWordLength = (lastWordindex - _currentInput.length);
  }

  void _endPractice() {
    for (int i = 0; i < _currentInput.length; i++) {
      if (_currentInput[i] == _practiceText[i]) {
        _totalCharactersCorrect++;
      }
    }
    setState(() {
      _wpm = _calculateWPM();
      _accuracy = _calculateAccuracy();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Practice completed!'
          'WPM: $_wpm'
          'Accuracy: $_accuracy',
        ),
      ),
    );
  }

  void _resetPractice() {
    Navigator.pop(context);
  }

  double _calculateWPM() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeElapsed = (currentTime - _startTime) / 1000;
    return (_practiceText.length / 5) / (timeElapsed / 60);
  }

  double _calculateAccuracy() {
    return (_totalCharactersCorrect / _practiceText.length) * 100;
  }

  Widget _buildTypingArea() {
    return Stack(
      children: [
        // Overlay text with user input
        RichText(
          softWrap: true,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              for (int i = 0; i < _currentInput.length; i++)
                TextSpan(
                  text: _practiceText[i],
                  style: TextStyle(
                    color:
                        i < _practiceText.length &&
                                _currentInput[i] == _practiceText[i]
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              if (_practiceText.length > _currentInput.length)
                TextSpan(text: "_", style: TextStyle(color: Colors.black)),
              TextSpan(
                text: "_" * (_lastWordLength - 1),
                style: TextStyle(color: Colors.transparent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Text(
                            _practiceText,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                          _buildTypingArea(),
                          Opacity(
                            opacity: 0,
                            child: TextField(
                              maxLines: null,
                              controller: _typingController,
                              autofocus: true,
                              //style: const TextStyle(color: Colors.transparent),
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.none,
                              focusNode: _focusNode,
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                _typingController
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: _typingController.text.length,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_isBlurred)
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () => _focusNode.requestFocus(),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Please click to resume to typing',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetPractice,
              child: const Text('Reset Practice'),
            ),
          ],
        ),
      ),
    );
  }
}
