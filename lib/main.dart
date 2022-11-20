import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flame/game.dart';
import 'dart:math';


main() async {
  var util = Util();
  await util.fullScreen();
  await util.setOrientation(DeviceOrientation.portraitUp);
  //loadimages
  //tissuebox : 0,1,2,3,4,5,6
  //background : b
  //crown : c
  //tissue : t
  await Flame.images.loadAll(['b', '0', '1', '2', '3', '4', '5', '6', 't', 'c']);
  audioLoad(c) async => (await Flame.audio.load(c)).path;
  setAudio(a, s, v) async {
    await a.setUrl(await audioLoad(s), isLocal: true);
    a.setVolume(v);
  }
  //audios
  //single drag : s.mp3
  //double drag : s.mp3
  //triple drag ： s.mp3
  //tick tock : tk.mp3
  //game over : a.mp3
  GameTable.setAudioList(GameTable.audioList1, await audioLoad('s.mp3'));
  GameTable.setAudioList(GameTable.audioList2, await audioLoad('d.mp3'));
  GameTable.setAudioList(GameTable.audioList3, await audioLoad('t.mp3'));
  await setAudio(GameTable.tickTock, 'tk.mp3', 1.0);
  await setAudio(GameTable.gameOver, 'a.mp3', .5);
  var game = GameTable((await SharedPreferences.getInstance()).getInt('hs') ?? 0);
  var hDrag = HorizontalDragGestureRecognizer();
  var vDrag = VerticalDragGestureRecognizer();
  hDrag.onUpdate = game.onDragUpdate;
  hDrag.onStart = game.onDragStart;
  hDrag.onEnd = game.onDragEnd;
  vDrag.onUpdate = game.onDragUpdate;
  vDrag.onStart = game.onDragStart;
  vDrag.onEnd = game.onDragEnd;
  runApp(game.widget);
  util.addGestureRecognizer(hDrag);
  util.addGestureRecognizer(vDrag);
}