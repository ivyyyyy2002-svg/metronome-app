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
  final TextEditingController _sequenceTextController = TextEditingController();
  String? _sequenceErrorText;

  @override
  void initState() {
    super.initState();
    widget.noteSequenceController.addListener(_syncSequenceText);
    _syncSequenceText();
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
    if (parseNoteSequenceText(text).isEmpty) return;

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

    if (parsedSequence.isEmpty) {
      setState(() {
        _sequenceErrorText = appTextFor(
          widget.appSettingsController.language,
        ).sequenceError;
      });
      return false;
    }

    final saved = await widget.noteSequenceController.setSequenceFromText(
      _sequenceTextController.text,
    );
    if (!saved) return false;
    if (mounted) {
      setState(() {
        _sequenceErrorText = null;
      });
    }
    return true;
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
    widget.noteSequenceController.removeListener(_syncSequenceText);
    _sequenceTextController.dispose();
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
                          // Note sequence input field
                          controller: _sequenceTextController,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: _sequenceErrorText,
                            labelText: text.notesToPlay,
                            hintText: 'ABCDEFGFEDCBA',
                            helperText: text.noteInputHelper,
                            helperMaxLines: 2,
                            errorMaxLines: 2,
                          ),
                          onChanged: _handleSequenceTextChanged,
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
                            ActionChip(
                              avatar: const Icon(
                                Icons.backspace_outlined,
                                size: 18,
                              ),
                              label: Text(text.deleteNote),
                              onPressed: _deleteLastNoteInput,
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.clear_rounded, size: 18),
                              label: Text(text.clearNotes),
                              onPressed: _clearNoteSequenceInput,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Example sequence display
                        Chip(label: Text(text.sequenceExample)),
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
