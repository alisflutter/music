// ignore: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    Key? key,
    required this.songModel,
    required this.audioPlayer,
  }) : super(key: key);

  // {Key? key,
  // required this.audioPlayer})
  // : super(key: key);

  final SongModel songModel;
  final AudioPlayer audioPlayer;
  // final GlobalKey<_NowPlayingState> key;
  // Function changeTrack;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  // final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = const Duration();
  Duration _postion = const Duration();
  // PlayerState _playerState ;
  bool _isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      _isPlaying = true;
      widget.audioPlayer.play();
    } on Exception {
      log('not playing');
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _postion = p;
      });
    });
  }

  // void onComplete() {
  //   setState(() => _playerState = PlayerState.);
  //   play(widget.songData.nextSong);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 177, 201, 201),
      // appBar: AppBar(
      //   backgroundColor: Colors.black45,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(right: 350, top: 13),
                child: (IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_downward_rounded,
                      size: 30,
                    )))),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 57,
                  ),
                  // height: 200,
                  // width: 200,
                  child: const Icon(
                    Icons.music_note_rounded,
                    size: 250,
                    color: const Color.fromARGB(255, 59, 98, 27),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 11),
                child: Text(
                  widget.songModel.displayNameWOExt,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.songModel.artist.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(1),
                ),
                Text(
                  _postion.toString().split(".")[0],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Slider(
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
                        //min: 0.0,
                        value: _postion.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        activeColor: Color.fromARGB(255, 100, 80, 7),
                        thumbColor: Color.fromARGB(255, 4, 69, 69),
                        onChanged: (double value) {
                          setState(() {
                            changeToSlider(value.toInt());
                            value = value;
                            // widget.audioPlayer
                            //     .seek(new Duration(seconds: value.toInt()));
                          });
                        })),
                Text(
                  _duration.toString().split(".")[0],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      widget.audioPlayer.hasPrevious
                          ? widget.audioPlayer.seekToPrevious()
                          : null;
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 55,
                      color: Color.fromARGB(255, 75, 57, 3),
                    )),
                Center(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          widget.audioPlayer.pause();
                          //  Icon(Icons.play_arrow);
                        } else {
                          widget.audioPlayer.play();
                          // Icon(Icons.pause);
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 55,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: IconButton(
                      onPressed: () {
                        // widget.audioPlayer.hasNext
                        //     ? widget.audioPlayer.seekToNext()
                        //     : null;
                        widget.audioPlayer.seekToNext();
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 55,
                        color: Color.fromARGB(255, 75, 57, 3),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void changeToSlider(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
