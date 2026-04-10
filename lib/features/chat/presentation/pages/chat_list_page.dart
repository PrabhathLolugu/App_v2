import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(t.chat.listPage));
  }
}
