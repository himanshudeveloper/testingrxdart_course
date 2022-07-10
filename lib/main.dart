import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(MaterialApp(
    title: 'New Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //create our behavior subject every time widget is re-build
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [Key],
    );
    //dispose of the old subject every time widget is re-build
    useEffect(() => subject.close, [subject]);

    final name = StreamController<String>();

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: subject.stream
                .distinct()
                .debounceTime(const Duration(seconds: 1)),
            initialData: 'Please Start tYping',
            builder: (context, snapshot) {
              return Text(snapshot.requireData);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: subject.sink.add,
        ),
      ),
    );
  }
}
