import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeSession {
  const PracticeSession({
    required this.startedAt,
    required this.durationSeconds,
    required this.bpm,
    required this.sequenceText,
  });

  final DateTime startedAt;
  final int durationSeconds;
  final int bpm;
  final String sequenceText;

  Map<String, dynamic> toJson() {
    return {
      'startedAt': startedAt.toIso8601String(),
      'durationSeconds': durationSeconds,
      'bpm': bpm,
      'sequenceText': sequenceText,
    };
  }

  static PracticeSession? fromJson(Map<String, dynamic> json) {
    final startedAtText = json['startedAt'];
    final durationSeconds = json['durationSeconds'];
    final bpm = json['bpm'];
    final sequenceText = json['sequenceText'];

    if (startedAtText is! String ||
        durationSeconds is! int ||
        bpm is! int ||
        sequenceText is! String) {
      return null;
    }

    final startedAt = DateTime.tryParse(startedAtText);
    if (startedAt == null || durationSeconds <= 0) return null;

    return PracticeSession(
      startedAt: startedAt,
      durationSeconds: durationSeconds,
      bpm: bpm,
      sequenceText: sequenceText,
    );
  }
}

class PracticeHistoryController extends ChangeNotifier {
  static const String _storageKey = 'practice_sessions';
  static const int _maxStoredSessions = 100;
  static const int minimumSessionSeconds = 5;

  List<PracticeSession> _sessions = [];
  bool _isLoaded = false;

  List<PracticeSession> get sessions => List.unmodifiable(_sessions);
  bool get isLoaded => _isLoaded;
  PracticeSession? get lastSession =>
      _sessions.isEmpty ? null : _sessions.first;

  int get todayPracticeSeconds {
    final now = DateTime.now();
    return _sessions
        .where((session) => _isSameLocalDay(session.startedAt, now))
        .fold<int>(0, (total, session) => total + session.durationSeconds);
  }

  int? get mostUsedBpm {
    if (_sessions.isEmpty) return null;

    final counts = <int, int>{};
    for (final session in _sessions) {
      counts[session.bpm] = (counts[session.bpm] ?? 0) + 1;
    }

    final entries = counts.entries.toList()
      ..sort((a, b) {
        final countCompare = b.value.compareTo(a.value);
        if (countCompare != 0) return countCompare;
        return a.key.compareTo(b.key);
      });
    return entries.first.key;
  }

  Future<void> load() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    _sessions = _decodeSessions(prefs.getString(_storageKey));
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> recordSession({
    required Duration duration,
    required int bpm,
    required String sequenceText,
    DateTime? startedAt,
  }) async {
    final durationSeconds = duration.inSeconds;
    if (durationSeconds < minimumSessionSeconds) return;

    final session = PracticeSession(
      startedAt: startedAt ?? DateTime.now(),
      durationSeconds: durationSeconds,
      bpm: bpm,
      sequenceText: sequenceText,
    );

    _sessions = [session, ..._sessions].take(_maxStoredSessions).toList();
    await _saveSessions();
    notifyListeners();
  }

  String formatDuration(int seconds) {
    if (seconds <= 0) return '0 min';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes == 0) return '$remainingSeconds sec';
    if (remainingSeconds == 0) return '$minutes min';
    return '$minutes min $remainingSeconds sec';
  }

  List<PracticeSession> _decodeSessions(String? rawJson) {
    if (rawJson == null || rawJson.isEmpty) return [];

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) return [];

      final sessions = <PracticeSession>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;
        final session = PracticeSession.fromJson(item);
        if (session == null) continue;
        sessions.add(session);
      }

      sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      return sessions.take(_maxStoredSessions).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _sessions.map((session) => session.toJson()).toList(growable: false),
    );
    await prefs.setString(_storageKey, encoded);
  }

  bool _isSameLocalDay(DateTime first, DateTime second) {
    final firstLocal = first.toLocal();
    final secondLocal = second.toLocal();
    return firstLocal.year == secondLocal.year &&
        firstLocal.month == secondLocal.month &&
        firstLocal.day == secondLocal.day;
  }
}
