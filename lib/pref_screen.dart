import 'package:flutter/material.dart';
import 'prefs.dart';

class PrefScreen extends StatefulWidget {
  const PrefScreen({super.key});

  @override
  State<PrefScreen> createState() => _PrefScreenState();
}

class _PrefScreenState extends State<PrefScreen> {
  String text_ = '';

  void update() {
    setState(() {
      Prefs.saveData('data', 'hello');
    });
  }

  void show() async {
    text_ = await Prefs.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('preferences')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: update, icon: const Icon(Icons.add)),
          Text(text_),
          IconButton(onPressed: show, icon: const Icon(Icons.search))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Prefs.getPrefs();
  }
}
