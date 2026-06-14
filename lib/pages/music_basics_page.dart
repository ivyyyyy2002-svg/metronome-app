import 'package:flutter/material.dart';

import 'app_settings_controller.dart';
import 'language/app_text.dart';

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
  });

  final AppSettingsController appSettingsController;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final text = appTextFor(appSettingsController.language);
    final scheme = Theme.of(context).colorScheme;
    final cardColor = scheme.brightness == Brightness.dark
        ? const Color(0xFF171A20)
        : Colors.white;
    final cards = [
      (text.bpmBasicsTitle, text.bpmBasicsBody),
      (text.timeSignatureBasicsTitle, text.timeSignatureBasicsBody),
      (text.subdivisionBasicsTitle, text.subdivisionBasicsBody),
      (text.downbeatBasicsTitle, text.downbeatBasicsBody),
      (text.westernNotationBasicsTitle, text.westernNotationBasicsBody),
      (text.easternNotationBasicsTitle, text.easternNotationBasicsBody),
      (text.octaveNotationBasicsTitle, text.octaveNotationBasicsBody),
      (text.groupedNotesBasicsTitle, text.groupedNotesBasicsBody),
      (text.heldNotesBasicsTitle, text.heldNotesBasicsBody),
      (text.jianpuBasicsTitle, text.jianpuBasicsBody),
    ];

    return ListView.separated(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: cards.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            text.basicsIntro,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          );
        }

        final card = cards[index - 1];
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.$1,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                card.$2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
