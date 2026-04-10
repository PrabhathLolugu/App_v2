import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';

class HomeContentPage extends StatelessWidget {
  const HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        t.home.content,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
