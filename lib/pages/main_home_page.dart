import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_settings_controller.dart';
import 'metronome/metronome_music.dart';
import 'metronome/note_sequence_controller.dart';
import 'music_basics_page.dart';
import 'practice_history_controller.dart';
import 'language/app_language_text.dart';
import 'language/app_text.dart';

// Main home page of the app, with a welcome message and button to start the metronome demo page.
class MainHomePage extends StatefulWidget {
  const MainHomePage({
    super.key,
    required this.noteSequenceController,
    required this.appSettingsController,
    required this.practiceHistoryController,
  });

  final NoteSequenceController noteSequenceController;
  final AppSettingsController appSettingsController;
  final PracticeHistoryController practiceHistoryController;

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

// State class for the main home page, managing the UI
// and navigation to the metronome demo page.
class _MainHomePageState extends State<MainHomePage> {
  static const int _savedSequencePreviewLimit = 3;
  static const double _sectionTopSpacing = 18;
  static const double _cardSpacing = 18;

  final TextEditingController _sequenceTextController = TextEditingController();
  final TextEditingController _sequenceNameController = TextEditingController();
  final TextEditingController _savedSearchController = TextEditingController();
  String? _sequenceErrorText;
  String? _sequenceNameErrorText;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.noteSequenceController.addListener(_handleSequenceControllerChanged);
    widget.practiceHistoryController.addListener(_refreshPracticeHistory);
    _savedSearchController.addListener(_refreshSavedSequenceList);
    _syncSequenceText();
  }

  void _refreshPracticeHistory() {
    if (!mounted) return;
    setState(() {});
  }

  void _handleSequenceControllerChanged() {
    _syncSequenceText();
    if (!mounted) return;
    setState(() {});
  }

  void _refreshSavedSequenceList() {
    if (!mounted) return;
    setState(() {});
  }

  List<SavedNoteSequence> _filteredSavedSequences([String? query]) {
    return widget.noteSequenceController.searchSavedSequences(
      query ?? _savedSearchController.text,
    );
  }

  SavedNoteSequence? _savedSequenceByName(String name) {
    final normalizedName = name.trim().toLowerCase();
    for (final savedSequence in widget.noteSequenceController.savedSequences) {
      if (savedSequence.name.toLowerCase() == normalizedName) {
        return savedSequence;
      }
    }
    return null;
  }

  // Compares two note sequences for equality, checking if they have the same notes in the same order.
  bool _hasSameSequence(
    List<String> firstSequence,
    List<String> secondSequence,
  ) {
    if (firstSequence.length != secondSequence.length) return false;

    for (int index = 0; index < firstSequence.length; index++) {
      if (firstSequence[index] != secondSequence[index]) return false;
    }
    return true;
  }

  Future<bool> _confirmReplaceSavedSequence(String name) async {
    final text = appTextFor(widget.appSettingsController.language);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(text.replaceSequenceQuestion(name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(text.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(text.replace),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  // Synchronizes the text in the sequence input field with the current
  // note sequence from the controller.
  void _syncSequenceText() {
    final nextText = widget.noteSequenceController.sequenceText;
    final currentText = _sequenceTextController.text;
    if (currentText == nextText) return;

    final currentSequence = parseNoteSequenceText(currentText);
    final nextSequence = parseNoteSequenceText(nextText);
    if (currentSequence.join('|') == nextSequence.join('|')) return;

    _sequenceTextController.text = nextText;
  }

  void _handleSequenceTextChanged(String text) {
    final parsedSequence = parseNoteSequenceText(text);
    if (parsedSequence.isEmpty ||
        parsedSequence.length > maxNoteSequenceLength) {
      return;
    }

    unawaited(widget.noteSequenceController.setSequenceFromText(text));

    if (_sequenceErrorText != null) {
      setState(() {
        _sequenceErrorText = null;
      });
    }
  }

  // Sets the text in the sequence input field, ensuring the
  // cursor is placed at the end, and triggers validation of the new text.
  void _setSequenceInputText(String text) {
    _sequenceTextController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );

    _handleSequenceTextChanged(text);
  }

  // Normalizes the spacing in the sequence input field, ensuring there is
  // only a single space between notes and no leading/trailing spaces.
  void _normalizeSequenceInputSpacing() {
    final formattedText = formatNoteSequenceText(_sequenceTextController.text);
    if (formattedText.isEmpty ||
        formattedText == _sequenceTextController.text) {
      return;
    }

    _sequenceTextController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  // Appends a note to the current sequence input, ensuring proper spacing.
  void _appendNoteToSequence(String note) {
    final currentText = _sequenceTextController.text.trim();
    final nextText = currentText.isEmpty
        ? note
        : currentText.endsWith('/')
        ? '$currentText$note'
        : '$currentText $note';

    _setSequenceInputText(nextText);
  }

  void _appendHoldToSequence() {
    final currentText = _sequenceTextController.text.trim();
    if (currentText.isEmpty || currentText.endsWith('/')) return;

    _setSequenceInputText('$currentText -');
  }

  void _appendGroupSeparatorToSequence() {
    final currentText = _sequenceTextController.text.trim();
    if (currentText.isEmpty ||
        currentText.endsWith('/') ||
        currentText.endsWith('-')) {
      return;
    }

    _setSequenceInputText('$currentText/');
  }

  void _applyOctaveMarkToLastNote(String mark) {
    final tokens = _sequenceTextController.text.trim().split(RegExp(r'\s+'));
    if (tokens.isEmpty || tokens.first.isEmpty) return;

    final lastToken = tokens.last;
    if (lastToken == '-' || lastToken.endsWith('/')) return;

    final baseToken = lastToken.replaceFirst(RegExp(r"[,']+$"), '');
    tokens[tokens.length - 1] = lastToken.endsWith(mark)
        ? baseToken
        : '$baseToken$mark';

    _setSequenceInputText(tokens.join(' '));
  }

  // Applies an accidental (sharp or flat) to the last note in the sequence input.
  void _applyAccidentalToLastNote(String accidental) {
    final tokens = _sequenceTextController.text.trim().split(RegExp(r'\s+'));

    if (tokens.isEmpty || tokens.first.isEmpty) return;

    final lastToken = tokens.last;
    final easternAccidentalToken = _toggleEasternAccidentalToken(
      lastToken,
      accidental,
    );
    if (easternAccidentalToken != null) {
      tokens[tokens.length - 1] = easternAccidentalToken;
      _setSequenceInputText(tokens.join(' '));
      return;
    }

    final parsedNotes = parseNoteSequenceText(lastToken);

    if (parsedNotes.length != 1 || parsedNotes.first.contains('/')) return;

    final baseNote = parsedNotes.first.substring(0, 1);
    tokens[tokens.length - 1] = parsedNotes.first.endsWith(accidental)
        ? baseNote
        : '$baseNote$accidental';

    _setSequenceInputText(tokens.join(' '));
  }

  String? _toggleEasternAccidentalToken(String token, String accidental) {
    final octaveSuffix = RegExp(r"[,']+$").firstMatch(token)?.group(0) ?? '';
    final baseToken = token.replaceFirst(RegExp(r"[,']+$"), '');

    const flatNotes = {'R': 'Rb', 'G': 'Gb', 'D': 'Db', 'N': 'Nb'};
    if (accidental == 'b') {
      String? natural;
      for (final entry in flatNotes.entries) {
        if (entry.value == baseToken) {
          natural = entry.key;
          break;
        }
      }
      if (natural != null) return '$natural$octaveSuffix';

      final flat = flatNotes[baseToken];
      if (flat != null) return '$flat$octaveSuffix';
    }

    if (accidental == '#') {
      if (baseToken == 'M#') return 'M$octaveSuffix';
      if (baseToken == 'M') return 'M#$octaveSuffix';
    }

    return null;
  }

  // Deletes the last note from the sequence input.
  void _deleteLastNoteInput() {
    final tokens = _sequenceTextController.text.trim().split(RegExp(r'\s+'));

    if (tokens.isEmpty || tokens.first.isEmpty) return;

    tokens.removeLast();

    _setSequenceInputText(tokens.join(' '));
  }

  void _clearNoteSequenceInput() {
    _setSequenceInputText('');
  }

  // Applies the custom note sequence entered by the user, validating it first.
  Future<bool> _applyCustomSequence() async {
    final parsedSequence = parseNoteSequenceText(_sequenceTextController.text);
    final text = appTextFor(widget.appSettingsController.language);

    if (parsedSequence.isEmpty) {
      setState(() {
        _sequenceErrorText = text.sequenceError;
      });
      return false;
    }

    if (parsedSequence.length > maxNoteSequenceLength) {
      setState(() {
        _sequenceErrorText = text.noteSequenceTooLong(maxNoteSequenceLength);
      });
      return false;
    }

    final formattedText = parsedSequence.join(' ');
    _sequenceTextController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );

    final saved = await widget.noteSequenceController.setSequenceFromText(
      formattedText,
    );
    if (!saved) return false;
    if (mounted) {
      setState(() {
        _sequenceErrorText = null;
      });
    }
    return true;
  }

  Future<void> _applyGeneratedPattern(String patternText) async {
    final text = appTextFor(widget.appSettingsController.language);
    final saved = await widget.noteSequenceController.setSequenceFromText(
      patternText,
    );
    if (!saved || !mounted) return;

    setState(() {
      _selectedTabIndex = 1;
      _sequenceErrorText = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text.patternAppliedNotice)));
  }

  // Saves the current note sequence with a user-provided name, validating the name first.
  Future<void> _saveNamedSequence() async {
    final text = appTextFor(widget.appSettingsController.language);
    final applied = await _applyCustomSequence();
    if (!applied || !mounted) return;

    final name = _sequenceNameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _sequenceNameErrorText = text.sequenceNameError;
      });
      return;
    }

    final existingSequence = _savedSequenceByName(name);
    if (existingSequence != null) {
      final currentSequence = parseNoteSequenceText(
        _sequenceTextController.text,
      );
      if (_hasSameSequence(currentSequence, existingSequence.sequence)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text.alreadySavedNotice)));
        return;
      }

      final shouldReplace = await _confirmReplaceSavedSequence(name);
      if (!shouldReplace || !mounted) return;
    }

    final saved = await widget.noteSequenceController.saveCurrentSequence(name);
    if (!saved || !mounted) return;

    setState(() {
      _sequenceNameErrorText = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text.sequenceSavedNotice)));
  }

  Future<void> _loadSavedSequence(SavedNoteSequence savedSequence) async {
    final imported = await widget.noteSequenceController.importSavedSequence(
      savedSequence,
    );
    if (!imported || !mounted) return;

    _sequenceTextController.value = TextEditingValue(
      text: savedSequence.sequenceText,
      selection: TextSelection.collapsed(
        offset: savedSequence.sequenceText.length,
      ),
    );
    _sequenceNameController.value = TextEditingValue(
      text: savedSequence.name,
      selection: TextSelection.collapsed(offset: savedSequence.name.length),
    );
  }

  Future<void> _deleteSavedSequence(SavedNoteSequence savedSequence) async {
    await widget.noteSequenceController.deleteSavedSequence(savedSequence.name);
  }

  // Opens the saved sequences bottom sheet, allowing the user to
  // load or delete saved sequences, with a search function to filter
  // sequences by name.
  Future<void> _openSavedSequencesSheet() async {
    final text = appTextFor(widget.appSettingsController.language);
    final searchController = TextEditingController(
      text: _savedSearchController.text,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        var filteredSequences = _filteredSavedSequences(searchController.text);

        return StatefulBuilder(
          builder: (context, setSheetState) {
            void refreshSheet() {
              setSheetState(() {
                filteredSequences = _filteredSavedSequences(
                  searchController.text,
                );
              });
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        text.savedSequences,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: text.searchSequences,
                        ),
                        onChanged: (_) => refreshSheet(),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: _SavedSequencesList(
                            savedSequences: filteredSequences,
                            emptyLabel: text.noSavedSequences,
                            loadLabel: text.loadSequence,
                            deleteLabel: text.deleteNote,
                            onLoad: (savedSequence) async {
                              await _loadSavedSequence(savedSequence);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            onDelete: (savedSequence) async {
                              await _deleteSavedSequence(savedSequence);
                              refreshSheet();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    searchController.dispose();
  }

  Future<void> _startMetronome() async {
    final saved = await _applyCustomSequence();
    if (!saved || !mounted) return;

    Navigator.of(context).pushNamed('/metronome');
  }

  // Opens the settings bottom sheet, allowing the user to change
  // theme and language preferences.
  void _openSettingsSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return AnimatedBuilder(
          animation: widget.appSettingsController,
          builder: (context, _) {
            final text = appTextFor(widget.appSettingsController.language);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text.settings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      text.appearance,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<ThemeMode>(
                      // Theme mode selection segmented button
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(text.system),
                          icon: const Icon(Icons.brightness_auto_rounded),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(text.light),
                          icon: const Icon(Icons.light_mode_rounded),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(text.dark),
                          icon: const Icon(Icons.dark_mode_rounded),
                        ),
                      ],
                      selected: {widget.appSettingsController.themeMode},
                      onSelectionChanged: (selection) {
                        widget.appSettingsController.setThemeMode(
                          selection.first,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      text.language,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<AppLanguage>(
                      initialValue: widget.appSettingsController.language,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.language_rounded),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: AppLanguage.english,
                          child: Text(text.english),
                        ),
                        DropdownMenuItem(
                          value: AppLanguage.chinese,
                          child: Text(text.chinese),
                        ),
                        DropdownMenuItem(
                          value: AppLanguage.french,
                          child: Text(text.french),
                        ),
                        DropdownMenuItem(
                          value: AppLanguage.hindi,
                          child: Text(text.hindi),
                        ),
                      ],
                      onChanged: (language) {
                        if (language == null) return;
                        widget.appSettingsController.setLanguage(language);
                        setState(() {
                          _sequenceErrorText = null;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      text.languageSavedNotice,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    widget.noteSequenceController.removeListener(
      _handleSequenceControllerChanged,
    );
    widget.practiceHistoryController.removeListener(_refreshPracticeHistory);
    _savedSearchController.removeListener(_refreshSavedSequenceList);
    _sequenceTextController.dispose();
    _sequenceNameController.dispose();
    _savedSearchController.dispose();
    super.dispose();
  }

  // Builds the UI for the main home page, including a welcome message
  // and a button to start the metronome demo page.
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = appTextFor(widget.appSettingsController.language);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF111827), Color(0xFF0F1E1B), Color(0xFF1C1914)]
        : const [Color(0xFFE7F0F5), Color(0xFFDCEDE7), Color(0xFFF5EAD8)];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _HomeTabBar(
        selectedIndex: _selectedTabIndex,
        labels: [
          text.practiceTab,
          text.sequencesTab,
          text.toolsTab,
          text.basicsTab,
        ],
        icons: const [
          Icons.play_arrow_rounded,
          Icons.library_music_rounded,
          Icons.apps_rounded,
          Icons.school_rounded,
        ],
        onSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Background gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SizedBox.expand(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text.homeTitle,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              text.appName,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: text.settings,
                        onPressed: _openSettingsSheet,
                        icon: const Icon(Icons.settings_rounded),
                      ),
                    ],
                  ),
                  if (_selectedTabIndex == 0) ...[
                    const SizedBox(height: _sectionTopSpacing),
                    Container(
                      // Main action card
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                      decoration: _homeCardDecoration(scheme),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Main action card title
                            text.readyTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // Main action card description
                            text.readyDescription,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            // Action buttons
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _startMetronome,
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: Text(text.startMetronome),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: _cardSpacing),
                    _PracticeHistoryCard(
                      title: text.practiceHistory,
                      todayLabel: text.todayPractice,
                      last7DaysLabel: text.last7Days,
                      lastSessionLabel: text.lastSession,
                      mostUsedBpmLabel: text.mostUsedBpm,
                      emptyLabel: text.noPracticeYet,
                      controller: widget.practiceHistoryController,
                    ),
                    const SizedBox(height: _cardSpacing),
                  ],

                  // Custom note sequence input cards
                  if (_selectedTabIndex == 1) ...[
                    const SizedBox(height: _sectionTopSpacing),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: _homeCardDecoration(scheme),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text.practiceNotePattern,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            text.notePatternDescription,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            // Note sequence input field, with validation and helper text
                            controller: _sequenceTextController,
                            textCapitalization: TextCapitalization.none,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              errorText: _sequenceErrorText,
                              labelText: text.notesToPlay,
                              hintText: 'A B C D E F G F E D C B A',
                              errorMaxLines: 2,
                            ),
                            onChanged: _handleSequenceTextChanged,
                            onEditingComplete: _normalizeSequenceInputSpacing,
                            onTapOutside: (_) =>
                                _normalizeSequenceInputSpacing(),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  text.noteInputHelper,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '${parseNoteSequenceText(_sequenceTextController.text).length} / $maxNoteSequenceLength',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Sequence name input field, with validation
                          TextField(
                            controller: _sequenceNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              errorText: _sequenceNameErrorText,
                              labelText: text.sequenceName,
                            ),
                            onChanged: (_) {
                              if (_sequenceNameErrorText == null) return;
                              setState(() {
                                _sequenceNameErrorText = null;
                              });
                            },
                          ),

                          // Note input action chips for quick entry of notes and accidentals
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final note in const [
                                'A',
                                'B',
                                'C',
                                'D',
                                'E',
                                'F',
                                'G',
                                'S',
                                'R',
                                'M',
                                'P',
                                'N',
                              ])
                                ActionChip(
                                  label: Text(note),
                                  onPressed: () => _appendNoteToSequence(note),
                                ),
                              ActionChip(
                                label: const Text('#'),
                                onPressed: () =>
                                    _applyAccidentalToLastNote('#'),
                              ),
                              ActionChip(
                                label: const Text('b'),
                                onPressed: () =>
                                    _applyAccidentalToLastNote('b'),
                              ),
                              ActionChip(
                                label: const Text("'"),
                                onPressed: () =>
                                    _applyOctaveMarkToLastNote("'"),
                              ),
                              ActionChip(
                                label: const Text(','),
                                onPressed: () =>
                                    _applyOctaveMarkToLastNote(','),
                              ),
                              ActionChip(
                                label: const Text('/'),
                                onPressed: _appendGroupSeparatorToSequence,
                              ),
                              ActionChip(
                                label: const Text('-'),
                                onPressed: _appendHoldToSequence,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              TextButton(
                                onPressed: _deleteLastNoteInput,
                                child: Text(text.deleteNote),
                              ),
                              TextButton(
                                onPressed: _clearNoteSequenceInput,
                                child: Text(text.clearNotes),
                              ),
                              FilledButton(
                                onPressed: _saveNamedSequence,
                                child: Text(text.saveSequence),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: _cardSpacing),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: _homeCardDecoration(scheme),
                      child: Builder(
                        builder: (context) {
                          final filteredSequences = _filteredSavedSequences();
                          final previewSequences = filteredSequences
                              .take(_savedSequencePreviewLimit)
                              .toList(growable: false);

                          return Column(
                            // Saved sequences section, with search and list of saved sequences
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      text.savedSequences,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  if (filteredSequences.isNotEmpty)
                                    Text(
                                      text.savedSequenceSummary(
                                        previewSequences.length,
                                        filteredSequences.length,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _savedSearchController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: text.searchSequences,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _SavedSequencesList(
                                savedSequences: previewSequences,
                                emptyLabel: text.noSavedSequences,
                                loadLabel: text.loadSequence,
                                deleteLabel: text.deleteNote,
                                onLoad: _loadSavedSequence,
                                onDelete: _deleteSavedSequence,
                              ),
                              if (filteredSequences.length >
                                  _savedSequencePreviewLimit) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _openSavedSequencesSheet,
                                    child: Text(text.viewAll),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  if (_selectedTabIndex == 2) ...[
                    const SizedBox(height: _sectionTopSpacing),
                    _ScalePatternGeneratorCard(
                      text: text,
                      onUsePattern: _applyGeneratedPattern,
                    ),
                    const SizedBox(height: _cardSpacing),
                    _JianpuConverterCard(
                      text: text,
                      onUsePattern: _applyGeneratedPattern,
                    ),
                  ],
                  if (_selectedTabIndex == 3) ...[
                    const SizedBox(height: _sectionTopSpacing),
                    MusicBasicsContent(
                      appSettingsController: widget.appSettingsController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _homeCardDecoration(ColorScheme scheme) {
  return BoxDecoration(
    color: scheme.surface,
    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: scheme.shadow.withValues(alpha: 0.09),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

const List<String> _westernRootKeys = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];

const List<String> _sharpNoteNames = [
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B',
];

const List<String> _flatNoteNames = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];

bool _usesFlatNames(String rootKey) {
  return rootKey.contains('b') || rootKey == 'F';
}

// A simple data class representing a musical scale pattern,
// defined by a list of intervals from the root note.
class _ScalePattern {
  const _ScalePattern({required this.id, required this.intervals});

  final String id;
  final List<int> intervals;
}

enum _ScalePatternDirection { ascending, descending, upAndDown }

enum _ScaleNotation { western, eastern }

class _ScalePatternGeneratorCard extends StatefulWidget {
  const _ScalePatternGeneratorCard({
    required this.text,
    required this.onUsePattern,
  });

  final AppLanguageText text;
  final ValueChanged<String> onUsePattern;

  @override
  State<_ScalePatternGeneratorCard> createState() =>
      _ScalePatternGeneratorCardState();
}

class _ScalePatternGeneratorCardState
    extends State<_ScalePatternGeneratorCard> {
  static const List<String> _easternRootKeys = [
    'S',
    'Rb',
    'R',
    'Gb',
    'G',
    'M',
    'M#',
    'P',
    'Db',
    'D',
    'Nb',
    'N',
  ];

  static const List<String> _easternNoteNames = [
    'S',
    'Rb',
    'R',
    'Gb',
    'G',
    'M',
    'M#',
    'P',
    'Db',
    'D',
    'Nb',
    'N',
  ];

  static const Map<String, int> _easternNoteToSemitone = {
    'S': 0,
    'Rb': 1,
    'R': 2,
    'Gb': 3,
    'G': 4,
    'M': 5,
    'M#': 6,
    'P': 7,
    'Db': 8,
    'D': 9,
    'Nb': 10,
    'N': 11,
  };

  // Predefined scale patterns with their corresponding intervals from the root note
  static const List<_ScalePattern> _scalePatterns = [
    _ScalePattern(id: 'majorPentatonic', intervals: [0, 2, 4, 7, 9]),
    _ScalePattern(id: 'minorPentatonic', intervals: [0, 3, 5, 7, 10]),
    _ScalePattern(id: 'majorScale', intervals: [0, 2, 4, 5, 7, 9, 11]),
    _ScalePattern(id: 'minorScale', intervals: [0, 2, 3, 5, 7, 8, 10]),
  ];

  _ScaleNotation _selectedNotation = _ScaleNotation.western;
  String _selectedRootKey = 'C';
  _ScalePattern _selectedScalePattern = _scalePatterns.first;
  _ScalePatternDirection _selectedDirection = _ScalePatternDirection.upAndDown;

  List<String> get _generatedNotes {
    final rootSemitone = _selectedNotation == _ScaleNotation.eastern
        ? _easternNoteToSemitone[_selectedRootKey] ?? 0
        : noteToSemitone[_selectedRootKey] ?? 0;
    final noteNames = _noteNamesForSelectedNotation();
    final scaleNotes = _selectedScalePattern.intervals
        .map((interval) {
          return noteNames[(rootSemitone + interval) % noteNames.length];
        })
        .toList(growable: false);

    switch (_selectedDirection) {
      case _ScalePatternDirection.ascending:
        return scaleNotes;
      case _ScalePatternDirection.descending:
        return scaleNotes.reversed.toList(growable: false);
      case _ScalePatternDirection.upAndDown:
        return [...scaleNotes, ...scaleNotes.reversed.skip(1)];
    }
  }

  String get _generatedPatternText => _generatedNotes.join(' ');

  List<String> get _currentRootKeys {
    return _selectedNotation == _ScaleNotation.eastern
        ? _easternRootKeys
        : _westernRootKeys;
  }

  List<String> _noteNamesForSelectedNotation() {
    if (_selectedNotation == _ScaleNotation.eastern) {
      return _easternNoteNames;
    }

    return _usesFlatNames(_selectedRootKey) ? _flatNoteNames : _sharpNoteNames;
  }

  String _notationLabel(_ScaleNotation notation) {
    switch (notation) {
      case _ScaleNotation.western:
        return widget.text.westernNotation;
      case _ScaleNotation.eastern:
        return widget.text.easternNotation;
    }
  }

  String _scalePatternLabel(_ScalePattern pattern) {
    switch (pattern.id) {
      case 'majorPentatonic':
        return widget.text.majorPentatonic;
      case 'minorPentatonic':
        return widget.text.minorPentatonic;
      case 'majorScale':
        return widget.text.majorScale;
      case 'minorScale':
        return widget.text.minorScale;
      default:
        return pattern.id;
    }
  }

  String _directionLabel(_ScalePatternDirection direction) {
    switch (direction) {
      case _ScalePatternDirection.ascending:
        return widget.text.ascending;
      case _ScalePatternDirection.descending:
        return widget.text.descending;
      case _ScalePatternDirection.upAndDown:
        return widget.text.upAndDown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dropdownTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: _homeCardDecoration(scheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text.scalePatternGenerator,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            widget.text.scalePatternDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<_ScaleNotation>(
            initialValue: _selectedNotation,
            isExpanded: true,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.text.notation,
            ),
            items: [
              for (final notation in _ScaleNotation.values)
                DropdownMenuItem(
                  value: notation,
                  child: Text(
                    _notationLabel(notation),
                    style: dropdownTextStyle,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedNotation = value;
                _selectedRootKey = value == _ScaleNotation.eastern ? 'S' : 'C';
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedRootKey,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.text.rootKey,
            ),
            items: [
              for (final rootKey in _currentRootKeys)
                DropdownMenuItem(
                  value: rootKey,
                  child: Text(rootKey, style: dropdownTextStyle),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedRootKey = value;
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<_ScalePattern>(
            initialValue: _selectedScalePattern,
            isExpanded: true,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.text.scale,
            ),
            items: [
              for (final pattern in _scalePatterns)
                DropdownMenuItem(
                  value: pattern,
                  child: Text(
                    _scalePatternLabel(pattern),
                    style: dropdownTextStyle,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedScalePattern = value;
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<_ScalePatternDirection>(
            initialValue: _selectedDirection,
            isExpanded: true,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.text.direction,
            ),
            items: [
              for (final direction in _ScalePatternDirection.values)
                DropdownMenuItem(
                  value: direction,
                  child: Text(
                    _directionLabel(direction),
                    style: dropdownTextStyle,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedDirection = value;
              });
            },
          ),
          const SizedBox(height: 14),
          Text(
            widget.text.generatedPattern,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _generatedPatternText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => widget.onUsePattern(_generatedPatternText),
              child: Text(widget.text.useAsSequence),
            ),
          ),
        ],
      ),
    );
  }
}

class _JianpuConverterCard extends StatefulWidget {
  const _JianpuConverterCard({required this.text, required this.onUsePattern});

  final AppLanguageText text;
  final ValueChanged<String> onUsePattern;

  @override
  State<_JianpuConverterCard> createState() => _JianpuConverterCardState();
}

class _JianpuConverterCardState extends State<_JianpuConverterCard> {
  static const List<int> _majorScaleIntervals = [0, 2, 4, 5, 7, 9, 11];

  final TextEditingController _jianpuController = TextEditingController(
    text: '1 2 3 5 6 5 3 2 1',
  );
  String _selectedRootKey = 'C';

  @override
  void dispose() {
    _jianpuController.dispose();
    super.dispose();
  }

  List<String> get _convertedNotes {
    final noteNames = _usesFlatNames(_selectedRootKey)
        ? _flatNoteNames
        : _sharpNoteNames;
    final rootSemitone = noteToSemitone[_selectedRootKey] ?? 0;
    final scaleNotes = _majorScaleIntervals
        .map((interval) => noteNames[(rootSemitone + interval) % 12])
        .toList(growable: false);
    final converted = <String>[];

    for (final token in _jianpuController.text.trim().split(RegExp(r'\s+'))) {
      if (token.isEmpty) continue;
      if (token == '-') {
        converted.add(token);
        continue;
      }

      final notesInBeat = <String>[];
      for (final char in token.characters) {
        final degree = int.tryParse(char);
        if (degree == null || degree < 1 || degree > 7) continue;
        notesInBeat.add(scaleNotes[degree - 1]);
      }

      if (notesInBeat.isNotEmpty) {
        converted.add(notesInBeat.join('/'));
      }
    }

    return converted.toList(growable: false);
  }

  String get _convertedPatternText => _convertedNotes.join(' ');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dropdownTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: _homeCardDecoration(scheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text.jianpuConverter,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            widget.text.jianpuConverterDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _selectedRootKey,
            style: dropdownTextStyle,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.text.rootKey,
            ),
            items: [
              for (final rootKey in _westernRootKeys)
                DropdownMenuItem(
                  value: rootKey,
                  child: Text(rootKey, style: dropdownTextStyle),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedRootKey = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _jianpuController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.text.jianpuInput,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          Text(
            widget.text.convertedSequence,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _convertedPatternText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _convertedNotes.isEmpty
                  ? null
                  : () => widget.onUsePattern(_convertedPatternText),
              child: Text(widget.text.useAsSequence),
            ),
          ),
        ],
      ),
    );
  }
}

// A custom bottom tab bar for the home page, allowing the user
// to switch between the Practice, Sequences, Tools, and Basics tabs.
class _HomeTabBar extends StatelessWidget {
  const _HomeTabBar({
    required this.selectedIndex,
    required this.labels,
    required this.icons,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<String> labels;
  final List<IconData> icons;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: SizedBox(
        height: 64,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: scheme.onSurface.withValues(alpha: 0.10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final segmentWidth = constraints.maxWidth / labels.length;
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        left: 6 + (segmentWidth * selectedIndex),
                        top: 6,
                        bottom: 6,
                        width: segmentWidth - 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer.withValues(
                              alpha: 0.34,
                            ),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: scheme.onPrimaryContainer.withValues(
                                alpha: 0.10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            for (int index = 0; index < labels.length; index++)
                              Expanded(
                                child: _HomeTabButton(
                                  label: labels[index],
                                  icon: icons[index],
                                  selected: selectedIndex == index,
                                  onTap: () => onSelected(index),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant.withValues(alpha: 0.78),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant.withValues(alpha: 0.82),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A card widget displaying the user's recent practice history,
// including today's practice time, most used BPM, last session details,
// and a chart of practice time over the last 7 days.
class _PracticeHistoryCard extends StatelessWidget {
  const _PracticeHistoryCard({
    required this.title,
    required this.todayLabel,
    required this.last7DaysLabel,
    required this.lastSessionLabel,
    required this.mostUsedBpmLabel,
    required this.emptyLabel,
    required this.controller,
  });

  final String title;
  final String todayLabel;
  final String last7DaysLabel;
  final String lastSessionLabel;
  final String mostUsedBpmLabel;
  final String emptyLabel;
  final PracticeHistoryController controller;

  List<_DailyPracticeTotal> _lastSevenDailyTotals() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      final seconds = controller.sessions
          .where((session) => _isSameLocalDay(session.startedAt, date))
          .fold<int>(0, (total, session) => total + session.durationSeconds);

      return _DailyPracticeTotal(date: date, seconds: seconds);
    });
  }

  bool _isSameLocalDay(DateTime first, DateTime second) {
    final firstLocal = first.toLocal();
    final secondLocal = second.toLocal();
    return firstLocal.year == secondLocal.year &&
        firstLocal.month == secondLocal.month &&
        firstLocal.day == secondLocal.day;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lastSession = controller.lastSession;
    final mostUsedBpm = controller.mostUsedBpm;
    final dailyTotals = _lastSevenDailyTotals();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: _homeCardDecoration(scheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PracticeStatPill(
                label: todayLabel,
                value: controller.formatDuration(
                  controller.todayPracticeSeconds,
                ),
              ),
              _PracticeStatPill(
                label: mostUsedBpmLabel,
                value: mostUsedBpm == null ? '--' : '$mostUsedBpm',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lastSessionLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            lastSession == null
                ? emptyLabel
                : '${controller.formatDuration(lastSession.durationSeconds)} · ${lastSession.bpm} BPM · ${lastSession.sequenceText}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  last7DaysLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                controller.formatDuration(
                  dailyTotals.fold<int>(0, (total, day) => total + day.seconds),
                ),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 132,
            width: double.infinity,
            child: CustomPaint(
              painter: _PracticeHistoryChartPainter(
                dailyTotals: dailyTotals,
                lineColor: scheme.primary,
                axisColor: scheme.outlineVariant,
                labelColor: scheme.onSurfaceVariant,
                emptyLabel: emptyLabel,
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple data class representing the total practice time for a single day,
// including the date and total seconds practiced.
class _DailyPracticeTotal {
  const _DailyPracticeTotal({required this.date, required this.seconds});

  final DateTime date;
  final int seconds;

  double get minutes => seconds / 60;
}

// Custom painter for drawing the practice history chart, which visualizes
// the user's practice time over the last 7 days, including axes, labels, and data points.
class _PracticeHistoryChartPainter extends CustomPainter {
  const _PracticeHistoryChartPainter({
    required this.dailyTotals,
    required this.lineColor,
    required this.axisColor,
    required this.labelColor,
    required this.emptyLabel,
    required this.textStyle,
  });

  final List<_DailyPracticeTotal> dailyTotals;
  final Color lineColor;
  final Color axisColor;
  final Color labelColor;
  final String emptyLabel;
  final TextStyle? textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 32.0;
    const rightPadding = 10.0;
    const topPadding = 12.0;
    const bottomPadding = 24.0;
    final chartRect = Rect.fromLTRB(
      leftPadding,
      topPadding,
      size.width - rightPadding,
      size.height - bottomPadding,
    );

    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;
    canvas.drawLine(chartRect.bottomLeft, chartRect.bottomRight, axisPaint);
    canvas.drawLine(chartRect.bottomLeft, chartRect.topLeft, axisPaint);

    final hasPractice = dailyTotals.any((day) => day.seconds > 0);
    final maxMinutes = _maxMinutes();
    _drawText(
      canvas,
      hasPractice ? '${maxMinutes.ceil()}m' : '0',
      Offset(0, chartRect.top - 6),
    );
    _drawText(canvas, '0', Offset(16, chartRect.bottom - 8));

    for (int index = 0; index < dailyTotals.length; index++) {
      final pointX = _pointX(chartRect, index);
      _drawCenteredText(
        canvas,
        '${dailyTotals[index].date.month}/${dailyTotals[index].date.day}',
        Offset(pointX, chartRect.bottom + 8),
      );
    }

    if (!hasPractice) {
      _drawText(
        canvas,
        emptyLabel,
        Offset(chartRect.left + 12, chartRect.center.dy - 8),
      );
      return;
    }

    final points = <Offset>[
      for (int index = 0; index < dailyTotals.length; index++)
        Offset(
          _pointX(chartRect, index),
          _pointY(chartRect, dailyTotals[index].minutes, maxMinutes),
        ),
    ];

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, linePaint);

    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(point, 3.5, pointPaint);
    }
  }

  double _maxMinutes() {
    var maxMinutes = 0.0;
    for (final day in dailyTotals) {
      if (day.minutes > maxMinutes) maxMinutes = day.minutes;
    }
    return maxMinutes == 0 ? 1 : maxMinutes;
  }

  double _pointX(Rect rect, int index) {
    if (dailyTotals.length <= 1) return rect.left;
    return rect.left + rect.width * index / (dailyTotals.length - 1);
  }

  double _pointY(Rect rect, double minutes, double maxMinutes) {
    final normalized = maxMinutes == 0 ? 0.0 : minutes / maxMinutes;
    return rect.bottom - rect.height * normalized;
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: (textStyle ?? const TextStyle(fontSize: 11)).copyWith(
          color: labelColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  void _drawCenteredText(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: (textStyle ?? const TextStyle(fontSize: 11)).copyWith(
          color: labelColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(offset.dx - painter.width / 2, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _PracticeHistoryChartPainter oldDelegate) {
    return oldDelegate.dailyTotals != dailyTotals ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.axisColor != axisColor ||
        oldDelegate.labelColor != labelColor ||
        oldDelegate.emptyLabel != emptyLabel ||
        oldDelegate.textStyle != textStyle;
  }
}

class _PracticeStatPill extends StatelessWidget {
  const _PracticeStatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying the list of saved note sequences,
// with options to load or delete each sequence,
// and a message when there are no saved sequences.
class _SavedSequencesList extends StatelessWidget {
  const _SavedSequencesList({
    required this.savedSequences,
    required this.emptyLabel,
    required this.loadLabel,
    required this.deleteLabel,
    required this.onLoad,
    required this.onDelete,
  });

  final List<SavedNoteSequence> savedSequences;
  final String emptyLabel;
  final String loadLabel;
  final String deleteLabel;
  final ValueChanged<SavedNoteSequence> onLoad;
  final ValueChanged<SavedNoteSequence> onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (savedSequences.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          emptyLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int index = 0; index < savedSequences.length; index++) ...[
            if (index > 0) Divider(height: 1, color: scheme.outlineVariant),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    savedSequences[index].name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    savedSequences[index].sequenceText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => onLoad(savedSequences[index]),
                        child: Text(loadLabel),
                      ),
                      TextButton(
                        onPressed: () => onDelete(savedSequences[index]),
                        child: Text(deleteLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
