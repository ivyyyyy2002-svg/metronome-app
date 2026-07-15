// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/foundation.dart';

class WebClickPlayer {
  static const int _poolSize = 3;

  List<html.AudioElement> _strongPlayers = const [];
  List<html.AudioElement> _weakPlayers = const [];
  int _strongIndex = 0;
  int _weakIndex = 0;

  void preload({required String strongAsset, required String weakAsset}) {
    dispose();
    _strongPlayers = List.generate(
      _poolSize,
      (_) => _createAudioElement(strongAsset),
    );
    _weakPlayers = List.generate(
      _poolSize,
      (_) => _createAudioElement(weakAsset),
    );
  }

  html.AudioElement _createAudioElement(String assetPath) {
    final source = Uri.base.resolve('assets/$assetPath').toString();
    return html.AudioElement()
      ..preload = 'auto'
      ..src = source
      ..load();
  }

  void play({required bool strong, required double volume}) {
    final players = strong ? _strongPlayers : _weakPlayers;
    if (players.isEmpty) return;

    final index = strong ? _strongIndex : _weakIndex;
    final player = players[index % players.length];
    if (strong) {
      _strongIndex = (index + 1) % players.length;
    } else {
      _weakIndex = (index + 1) % players.length;
    }

    player
      ..pause()
      ..currentTime = 0
      ..volume = volume.clamp(0.0, 1.0);

    // Do not await before this call: it must occur inside the browser's Start
    // interaction stack or Chrome will reject the short sound as autoplay.
    player.play().catchError((Object error) {
      debugPrint('Failed to play native web click: $error');
    });
  }

  void stop() {
    for (final player in [..._strongPlayers, ..._weakPlayers]) {
      player
        ..pause()
        ..currentTime = 0;
    }
  }

  void dispose() {
    for (final player in [..._strongPlayers, ..._weakPlayers]) {
      player
        ..pause()
        ..removeAttribute('src')
        ..load();
    }
    _strongPlayers = const [];
    _weakPlayers = const [];
    _strongIndex = 0;
    _weakIndex = 0;
  }
}
