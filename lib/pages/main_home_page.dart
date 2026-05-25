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
    if (_sequenceTextController.text == nextText) return;
    _sequenceTextController.text = nextText;
  }

  void _handleSequenceTextChanged(String text) {
    if (_sequenceErrorText == null) return;
    if (parseNoteSequenceText(text).isEmpty) return;

    setState(() {
      _sequenceErrorText = null;
    });
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
    if (!mounted) return false;

    setState(() {
      _sequenceErrorText = null;
    });
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            appTextFor(
              widget.appSettingsController.language,
            ).sequenceSavedNotice,
          ),
        ),
      );
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
                          controller: _sequenceTextController,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: _sequenceErrorText,
                            labelText: text.notesToPlay,
                            hintText: 'ABCDEFGFEDCBA',
                            helperText: text.noteInputHelper,
                          ),
                          onChanged: _handleSequenceTextChanged,
                        ),
                        const SizedBox(height: 12),
                        Chip(label: Text(text.sequenceExample)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _applyCustomSequence,
                            icon: const Icon(Icons.check_rounded),
                            label: Text(text.applySequence),
                          ),
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
