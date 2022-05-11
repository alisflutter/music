import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _songFile();
}

class _songFile extends State<MyApp> {
  final audio = new OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Music'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.music_note_rounded),
            title: Text("music$index"),
            subtitle: Text('arist'),
            trailing: Icon(Icons.more_horiz),
            onTap: () {},
          ),
          itemCount: 50,
        ),
      ),
    );
  }
}
