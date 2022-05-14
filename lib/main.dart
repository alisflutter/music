import 'package:flutter/material.dart';
import 'package:music/nowPlaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

import 'dart:developer';

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
  int currentIndex = 0;

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
        // _requestfor();
        _request();
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

  void _request() {
    Permission.storage.request();
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != _audioPlayer.nextIndex) {
        currentIndex++;
      }
    } else {
      if (currentIndex != _audioPlayer.previousIndex) {
        currentIndex--;
      }
    }
    // key.currentState.playSong();
  }

// setCurrentIndex(int index) {
//     var _currentSongIndex = index;
//   }

// SongModel get nextSong {
//     if (_currentSongIndex <  length) {
//       _currentSongIndex++;
//     }
//     if (_currentSongIndex >= length) return null;
//     return _songs[_currentSongIndex];
//   }

  final OnAudioQuery audio = new OnAudioQuery();

  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Music'),
          backgroundColor: Colors.black45,
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
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 26,
                      color: Colors.limeAccent,
                    )),
                title: Text(
                  item.data![index].displayNameWOExt,
                  maxLines: 1,
                ),
                subtitle: Text('${item.data![index].artist}'),
                trailing: const Icon(Icons.more_horiz),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NowPlaying(
                              songModel: item.data![index],
                              audioPlayer: _audioPlayer,

                              // changeTrack: changeTrack,
                            )),
                  );
                },
              ),
              itemCount: item.data!.length,
            );
          },
        ),
      ),
    );
  }
}
