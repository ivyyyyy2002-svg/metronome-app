import 'package:flutter/material.dart';

import 'app_settings_controller.dart';
import 'language/app_text.dart';
import '../theme/glass.dart';

// A simple page providing basic music theory information relevant to using the metronome app
class MusicBasicsPage extends StatelessWidget {
  const MusicBasicsPage({super.key, required this.appSettingsController});

  final AppSettingsController appSettingsController;

  @override
  Widget build(BuildContext context) {
    final text = appTextFor(appSettingsController.language);

    return Scaffold(
      appBar: AppBar(title: Text(text.musicBasics)),
      body: MusicBasicsContent(appSettingsController: appSettingsController),
    );
  }
}

class MusicBasicsContent extends StatelessWidget {
  const MusicBasicsContent({
    super.key,
    required this.appSettingsController,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 24),
    this.shrinkWrap = false,
    this.physics,
    this.cardKeys,
  });

  final AppSettingsController appSettingsController;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  /// Optional keys attached to individual term cards (by index) so the
  /// onboarding tutorial can highlight and explain specific terms.
  final Map<int, Key>? cardKeys;

  @override
  Widget build(BuildContext context) {
    final text = appTextFor(appSettingsController.language);
    final scheme = Theme.of(context).colorScheme;
    final cards = [
      (text.bpmBasicsTitle, text.bpmBasicsBody, Icons.speed_rounded),
      (
        text.timeSignatureBasicsTitle,
        text.timeSignatureBasicsBody,
        Icons.looks_4_rounded,
      ),
      (
        text.subdivisionBasicsTitle,
        text.subdivisionBasicsBody,
        Icons.call_split_rounded,
      ),
      (
        text.downbeatBasicsTitle,
        text.downbeatBasicsBody,
        Icons.keyboard_double_arrow_down_rounded,
      ),
      (
        text.westernNotationBasicsTitle,
        text.westernNotationBasicsBody,
        Icons.music_note_rounded,
      ),
      (
        text.easternNotationBasicsTitle,
        text.easternNotationBasicsBody,
        Icons.public_rounded,
      ),
      (
        text.octaveNotationBasicsTitle,
        text.octaveNotationBasicsBody,
        Icons.swap_vert_rounded,
      ),
      (
        text.groupedNotesBasicsTitle,
        text.groupedNotesBasicsBody,
        Icons.join_full_rounded,
      ),
      (
        text.heldNotesBasicsTitle,
        text.heldNotesBasicsBody,
        Icons.horizontal_rule_rounded,
      ),
      (text.jianpuBasicsTitle, text.jianpuBasicsBody, Icons.pin_rounded),
    ];

    return ListView.separated(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: cards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final card = cards[index];
        return GlassCard(
          key: cardKeys?[index],
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          borderRadius: 18,
          blur: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(card.$3, size: 19, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.$1,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      card.$2,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
