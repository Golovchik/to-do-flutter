import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          title: Text('To-do list'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text('Main screen'),
            ElevatedButton(
              onPressed: () {
                //Navigator.pushNamed(context, '/todo');
                //Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => false);
                Navigator.pushReplacementNamed(context, '/todo');
              },
              child: Text('Перейти далее'),
            ),
          ],
        ));
  }
}
