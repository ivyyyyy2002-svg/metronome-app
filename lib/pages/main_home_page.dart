import 'dart:async';

import 'package:flutter/material.dart';

import 'app_settings_controller.dart';
import 'metronome/metronome_music.dart';
import 'metronome/note_sequence_controller.dart';
import 'language/app_text.dart';

// Main home page of the app, with a welcome message and button to start the metronome demo page.
class MainHomePage extends StatefulWidget {
  const MainHomePage({
    super.key,
    required this.noteSequenceController,
    required this.appSettingsController,
  });

  final NoteSequenceController noteSequenceController;
  final AppSettingsController appSettingsController;

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

// State class for the main home page, managing the UI
// and navigation to the metronome demo page.
class _MainHomePageState extends State<MainHomePage> {
  static const int _savedSequencePreviewLimit = 3;

  final TextEditingController _sequenceTextController = TextEditingController();
  final TextEditingController _sequenceNameController = TextEditingController();
  final TextEditingController _savedSearchController = TextEditingController();
  String? _sequenceErrorText;
  String? _sequenceNameErrorText;

  @override
  void initState() {
    super.initState();
    widget.noteSequenceController.addListener(_handleSequenceControllerChanged);
    _savedSearchController.addListener(_refreshSavedSequenceList);
    _syncSequenceText();
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
    final nextText = currentText.isEmpty ? note : '$currentText $note';

    _setSequenceInputText(nextText);
  }

  // Applies an accidental (sharp or flat) to the last note in the sequence input.
  void _applyAccidentalToLastNote(String accidental) {
    final tokens = _sequenceTextController.text.trim().split(RegExp(r'\s+'));

    if (tokens.isEmpty || tokens.first.isEmpty) return;

    final lastToken = tokens.last;
    final parsedNotes = parseNoteSequenceText(lastToken);

    if (parsedNotes.length != 1) return;

    final baseNote = parsedNotes.first.substring(0, 1);
    tokens[tokens.length - 1] = parsedNotes.first.endsWith(accidental)
        ? baseNote
        : '$baseNote$accidental';

    _setSequenceInputText(tokens.join(' '));
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
        ? const [Color(0xFF111827), Color(0xFF10201D), Color(0xFF1F1B14)]
        : const [Color(0xFFF2F8FF), Color(0xFFE8F6F2), Color(0xFFFFF8EC)];

    return Scaffold(
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                  const SizedBox(height: 16),
                  Container(
                    // Main action card
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
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
                  const SizedBox(height: 18),

                  // Custom note sequence input card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
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
                          onTapOutside: (_) => _normalizeSequenceInputSpacing(),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${text.noteInputHelper} ${text.noteSequenceTooLong(maxNoteSequenceLength)}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${parseNoteSequenceText(_sequenceTextController.text).length} / $maxNoteSequenceLength',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
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
                            for (final note in const ['A', 'B', 'C', 'D', 'E'])
                              ActionChip(
                                label: Text(note),
                                onPressed: () => _appendNoteToSequence(note),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final note in const ['F', 'G'])
                              ActionChip(
                                label: Text(note),
                                onPressed: () => _appendNoteToSequence(note),
                              ),
                            ActionChip(
                              label: const Text('#'),
                              onPressed: () => _applyAccidentalToLastNote('#'),
                            ),
                            ActionChip(
                              label: const Text('b'),
                              onPressed: () => _applyAccidentalToLastNote('b'),
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
                        const SizedBox(height: 8),
                        Text(
                          text.sequenceExample,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            final filteredSequences = _filteredSavedSequences();
                            final previewSequences = filteredSequences
                                .take(_savedSequencePreviewLimit)
                                .toList(growable: false);

                            return Column(// Saved sequences section, with search and list of saved sequences
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        text.savedSequences,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
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
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _savedSearchController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: text.searchSequences,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                      ],
                    ),
                  ),
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
