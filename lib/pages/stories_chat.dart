import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryGeneratorPage extends StatefulWidget {
  const StoryGeneratorPage({super.key});

  @override
  State<StoryGeneratorPage> createState() => _StoryGeneratorPageState();
}

class _StoryGeneratorPageState extends State<StoryGeneratorPage>
    with SingleTickerProviderStateMixin {
  TextEditingController promptController = TextEditingController();
  bool _isChatStarted = false;

  List<Map<String, String>> chatHistory = [];

  // Story options data
  Map<String, String> selectedOptions = {
    'storyType': '',
    'theme': '',
    'mainCharacter': '',
    'setting': '',
    'scripture': '',
    'storyLength': 'Medium',
    'language': 'English',
  };

  final Map<String, List<String>> storyOptions = {
    'storyType': ['Epic', 'Moral Tale', 'Adventure', 'Historical'],
    'theme': ['Heroic', 'Mysterious', 'Tragic', 'Comedic'],
    'mainCharacter': ['Warrior', 'Sage', 'Villain', 'Hero'],
    'setting': ['Ancient', 'Mythical', 'Celestial', 'Earthly'],
    'scripture': [
      'Ramayana',
      'Mahabharata',
      'Vedas',
      'Upanishads',
      'Bhagavad Gita',
    ],
  };
  List<bool> selectedMode = [true, false];

  void sendMessage() {
    if (promptController.text.isEmpty) return;

    setState(() {
      if (!_isChatStarted) {
        _isChatStarted = true;
      }

      chatHistory.add({'type': 'user', 'message': promptController.text});

      // Simulate bot response
      Future.delayed(Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            chatHistory.add({
              'type': 'bot',
              'message':
                  'Generating your scriptural story with the selected options...',
            });
          });
        }
      });

      promptController.clear();
    });
  }

  void randomizeAll() {
    setState(() {
      final random = DateTime.now().millisecond;
      selectedOptions['storyType'] = storyOptions['storyType']![random % 4];
      selectedOptions['theme'] = storyOptions['theme']![random % 4];
      selectedOptions['mainCharacter'] =
          storyOptions['mainCharacter']![random % 4];
      selectedOptions['setting'] = storyOptions['setting']![random % 4];
      selectedOptions['scripture'] = storyOptions['scripture']![random % 5];
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    // bool isDark = Theme.of(context).brightness == Brightness.dark;
    // double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Container(
      padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.005),
      height: height,
    );
  }
}
