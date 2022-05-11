// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _songFile();
}

class _songFile extends State<MyApp> {
  late Permission
      permission; //                                        //  request for permission
  PermissionStatus permissionStatus = PermissionStatus.denied;

  void initState() {
    _listionfor();
    super.initState();
    // _request();
  }

  Future<void> _requestfor() async {
    final status = await Permission.storage.request();
    setState(() {
      permissionStatus = status;
    });
  }

  void _listionfor() async {
    final status = await Permission.storage.status;

    setState(() {
      permissionStatus = status;
    });

    switch (status) {
      case PermissionStatus.denied:
        _requestfor();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);
        break;
      default:
        break;
    }
  }

  // void _request() {
  //   Permission.storage.request();
  // }

  final audio = new OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Music'),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: audio.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return Center(
                  // child: Text('No song found'),
                  // child: CircularProgressIndicator(),
                  );
            }

            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.music_note_rounded),
                title: Text(item.data![index].displayNameWOExt),
                subtitle: Text('${item.data![index].artist}'),
                trailing: Icon(Icons.more_horiz),
                onTap: () {},
              ),
              itemCount: item.data!.length,
            );
          },
        ),
      ),
    );
  }
}
