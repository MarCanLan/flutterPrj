import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recuperar el valor d' 'un camp de text',
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});
  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar el valor d\'un camp de text'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: myController,
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text('Martina Cañamares S2AM 25-26'),
                      children: [
                        Text(myController.text),
                      ],
                    );
                  },
                );
              },
              tooltip: 'Mostra el valor!',
              child: const Icon(Icons.text_fields),
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Martina Cañamares S2AM 25-26'),
                    duration: Duration(seconds: 5),
                  ),
                );
              },
              tooltip: 'Mostra el valor!',
              child: const Icon(Icons.text_fields),
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 164, 7),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(myController.text),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Tancar BottomSheet'),
                                )
                              ],
                            ),
                          ));
                    });
              },
              tooltip: 'Mostra el valor!',
              child: const Icon(Icons.text_fields),
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              heroTag: "btn4",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Martina Cañamares S2AM 25-26'),
                      content: Text(myController.text),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Exit'))
                      ],
                    );
                  },
                );
              },
              tooltip: 'Mostra el valor!',
              child: const Icon(Icons.text_fields),
            ),
          ],
        ));
  }
}
