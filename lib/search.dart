import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                child: Text('How are you'),
              ),
              Divider(),
              Container(
                height: 50,
                child: Text('How are you'),
              ),
            ],
          ),
          shadowColor: Colors.cyan,
          elevation: 15,
        ));
  }
}
