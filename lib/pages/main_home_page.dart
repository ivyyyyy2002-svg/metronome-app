import 'package:flutter/material.dart';

import 'metronome/note_sequence_controller.dart';
import 'metronome/metronome_music.dart';

// Main home page of the app, with a welcome message and button to start the metronome demo page.
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key, required this.noteSequenceController});

  final NoteSequenceController noteSequenceController;

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
        _sequenceErrorText =
            'Enter at least one note from A-G. You can also use sharps (#) and flats (b).';
      });
      return false;
    }

    final saved = await widget.noteSequenceController.setSequenceFromText(
      _sequenceTextController.text,
    );
    if (!saved) return false;

    setState(() {
      _sequenceErrorText = null;
    });
    return true;
  }

  Future<void> _startMetronome() async {
    final saved = await _applyCustomSequence();
    if (!saved || !mounted) return;

    Navigator.of(context).pushNamed('/metronome');
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

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Background gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF2F8FF), Color(0xFFE8F6F2), Color(0xFFFFF8EC)],
          ),
        ),
        child: SizedBox.expand(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // App title
                    'Metronome Studio',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    // App description
                    'Practice with tempo control, meter shaping, and sound layers.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
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
                          'Hello, \nReady to Practice?',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          // Main action card description
                          'Tap the button below to start a new metronome session with your last used settings.',
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
                                label: const Text('Start Metronome'),
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
                          'Practice Note Pattern',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose the order of notes the metronome will play.',
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
                            labelText: 'Notes to play',
                            hintText: 'ABCDEFGFEDCBA',
                            helperText:
                                'Use A-G, or add sharps/flats like C# and Bb.',
                            suffixIcon: IconButton(
                              tooltip: 'Apply sequence',
                              onPressed: _applyCustomSequence,
                              icon: Icon(
                                _sequenceErrorText == null
                                    ? Icons.check_rounded
                                    : Icons.error_outline_rounded,
                                color: _sequenceErrorText == null
                                    ? scheme.primary
                                    : scheme.error,
                              ),
                            ),
                          ),
                          onChanged: _handleSequenceTextChanged,
                          onSubmitted: (_) => _applyCustomSequence(),
                        ),
                        const SizedBox(height: 12),
                        const Chip(
                          label: Text('Examples: ABCDEFG, C#D#EF#G#, etc.'),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _applyCustomSequence,
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Apply Sequence'),
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
